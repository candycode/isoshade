// Raytracing of iso-functions and volumetric data
// Copyright (c) Ugo Varetto
// WARNING: requires OSG to pass osg_Viewport uniform to shaders
//          either modify OSG or add a pre draw camera callback
//          to pass the uniform to the shaders

#include <iostream>
#include <string>
#include <sstream>
#include <stdexcept>
#include <vector>
#include <fstream>

#include <osgViewer/Viewer>
#include <osgViewer/ViewerEventHandlers>
#include <osg/Texture1D>
#include <osg/Node>
#include <osg/Notify>
#include <osg/PolygonMode>

#include <osgDB/Registry>
#include <osgDB/ReadFile>

#include <osgGA/TrackballManipulator>
#include <osgGA/FlightManipulator>
#include <osgGA/DriveManipulator>
#include <osgGA/AnimationPathManipulator>

#include <osgDB/WriteFile>
#include <osgDB/FileUtils>
#include <osgDB/FileNameUtils>

#include <osg/ShapeDrawable>
#include <osg/Shape>

#include <osgManipulator/TabBoxDragger>
#include <osg/MatrixTransform>

osg::Program* CreatePassThroughProgram()
{
	static const char PASSTHROUGH_VERT[] =
	"varying vec4 color;"
	"void main(void)\n"
	"{\n"
	"  color = gl_FrontMaterial.diffuse;\n"
	"  gl_Position = ftransform();\n"
	"}\n";

	static const char PASSTHROUGH_FRAG[] =
	"varying vec4 color;"
	"void main(void)\n"
	"{\n"
	"  gl_FragColor = color;\n"
	"}\n";


	osg::ref_ptr< osg::Program > p = new osg::Program;
    p->addShader( new osg::Shader( osg::Shader::FRAGMENT, PASSTHROUGH_FRAG ) );
	p->addShader( new osg::Shader( osg::Shader::VERTEX,   PASSTHROUGH_VERT ) );
	return p.release();
}


osgManipulator::Dragger* CreateManipulator( osg::MatrixTransform* mt )
{
	if( !mt ) throw std::runtime_error( "NULL matrix transform" );
	if( !mt ) return 0; // in case exceptions not enabled
	osg::ref_ptr< osgManipulator::Dragger > dragger = new osgManipulator::TabBoxDragger;
	const float scale = mt->getBound().radius() * 1.2f;
    dragger->setMatrix( osg::Matrix::scale( scale, scale, scale ) *
                        osg::Matrix::translate( mt->getBound().center() ) );
    dragger->setHandleEvents( true );
    dragger->addTransformUpdating( mt );
	dragger->setupDefaultGeometry();

	
    dragger->getOrCreateStateSet()->setAttributeAndModes( CreatePassThroughProgram(), osg::StateAttribute::OVERRIDE );
	return dragger.release();
}



int main( int argc, char **argv )
{
    try
    {
        // use an ArgumentParser object to manage the program arguments.
        osg::ArgumentParser arguments(&argc,argv);
        arguments.getApplicationUsage()->addCommandLineOption( "-vert",  "Vertex shader file" );
	    arguments.getApplicationUsage()->addCommandLineOption( "-frag",  "Fragment shader file" );
        arguments.getApplicationUsage()->addCommandLineOption( "-bk", "Background color \"r g b\"" );
        arguments.getApplicationUsage()->addCommandLineOption( "-fun", "Shader implementing 'float isofun(vec3 pos)' function" );
        arguments.getApplicationUsage()->addCommandLineOption( "-boxSize", "\"x-size y-size z-size\"" );
        arguments.getApplicationUsage()->addCommandLineOption( "-colormap", "file name of RGBA colormap" );
        arguments.getApplicationUsage()->addCommandLineOption( "-material", "file name of material shader used to compute colors" );
        arguments.getApplicationUsage()->addCommandLineOption( "-drawbox", "file name of material shader used to compute colors" );
        std::string vertShader;
        std::string fragShader;
        std::string funShader;
        std::string matShader;
        if( !arguments.read( "-vert", vertShader ) ) throw std::logic_error( "No vertex shader specified" );
        if( !arguments.read( "-frag", fragShader ) ) throw std::logic_error( "No fragment shader specified" );
        arguments.read( "-fun", funShader );
        arguments.read( "-material", matShader );
        std::string rgbs;
        float bkR = 0.0f;
        float bkG = 0.0f;
        float bkB = 0.0f;
        std::string boxSize;
        float boxSizeX = 4.0f;
        float boxSizeY = 4.0f;
        float boxSizeZ = 4.0f;

        if( arguments.read( "-bk", rgbs ) )
        {
            std::stringstream is( rgbs );
            if( !is ) throw std::logic_error( "error reading r component of background color" );
            is >> bkR;
            if( !is ) throw std::logic_error( "error reading g component of background color" );
            is >> bkG;
            if( !is ) throw std::logic_error( "error reading b component of background color" );
            is >> bkB;
        }

        if( arguments.read( "-boxSize", boxSize ) )
        {
            std::stringstream is( boxSize );
            if( !is ) throw std::logic_error( "error reading x component of box size" );
            is >> boxSizeX;
            if( !is ) throw std::logic_error( "error reading y component of box size" );
            is >> boxSizeY;
            if( !is ) throw std::logic_error( "error reading z component of box size" );
            is >> boxSizeZ;
        }

        std::string cmapfile;
        std::vector< float > cmapImage;
        if( arguments.read( "-colormap", cmapfile ) )
        {
            std::ifstream is( cmapfile.c_str() );
            if( !is ) throw std::runtime_error( "Cannot open file " + cmapfile );
            float r = float();
            float g = float();
            float b = float();
            float a = float();
            size_t size = 0;
            is >> size;
            cmapImage.reserve( size );
            if( !is.good() ) throw std::logic_error( "Cannot read Red component from colormap file" );
            while( is.good() )
            {
                is >> r;
                if( is.eof() ) break;
                if( !is.good() ) throw std::logic_error( "Cannot read Green component from colormap file" );
                is >> g;
                if( !is.good() ) throw std::logic_error( "Cannot read Blue component from colormap file" );
                is >> b;
                if( !is.good() ) throw std::logic_error( "Cannot read Alpha component from colormap file" );
                is >> a;
                cmapImage.push_back( r );
                cmapImage.push_back( g );
                cmapImage.push_back( b );
                cmapImage.push_back( a );
            }
        }

        // construct the viewer.
        osgViewer::Viewer viewer;
           
		osg::ref_ptr< osg::Node > model = osgDB::readNodeFiles( arguments );
		if( model == 0 ) 
		{
			osg::ref_ptr< osg::Geode > geode = new osg::Geode;
			geode->addDrawable( new osg::ShapeDrawable( new osg::Box( osg::Vec3( 0.f, 0.f, 0.f ), boxSizeX, boxSizeY, boxSizeZ ) ) );
			model = geode;
			model->getOrCreateStateSet()->addUniform( new osg::Uniform( "halfBoxSize", osg::Vec3( .5f * boxSizeX, .5f * boxSizeY, .5f * boxSizeZ ) ) );
			
		}
		else
		{
			const float scale = .5f * model->getBound().radius();
			model->getOrCreateStateSet()->addUniform( new osg::Uniform( "halfBoxSize", osg::Vec3( .5f * scale, .5f * scale, .5f * scale ) ) );
		}
		osg::StateSet* set = model->getOrCreateStateSet();
        osg::ref_ptr< osg::Program > aprogram;
        aprogram = new osg::Program;
        aprogram->setName( "iso" );
        aprogram->addShader( osg::Shader::readShaderFile( osg::Shader::FRAGMENT, fragShader  ) );
        // if fun shader available the fragment shader will invoke the 'isofun' function
        // implemented in this shader
        if( !funShader.empty() ) aprogram->addShader( osg::Shader::readShaderFile( osg::Shader::FRAGMENT, funShader ) );
        // load material shader if specified
        if( !matShader.empty() ) aprogram->addShader( osg::Shader::readShaderFile( osg::Shader::FRAGMENT, matShader ) );
        aprogram->addShader( osg::Shader::readShaderFile( osg::Shader::VERTEX, vertShader ) );
        set->setAttributeAndModes( aprogram.get(), osg::StateAttribute::ON );
	    
	    set->setMode( GL_BLEND, osg::StateAttribute::ON ); 
        if( !cmapImage.empty() )
        {
            osg::ref_ptr< osg::Image > image = new osg::Image;
            image->setImage( cmapImage.size() / 4, 1, 1,
                             GL_RGBA, GL_RGBA, GL_FLOAT,
                             reinterpret_cast< unsigned char* >( &cmapImage[ 0 ] ),
                             osg::Image::USE_NEW_DELETE );
            osg::ref_ptr< osg::Texture1D > cmapTexture = new osg::Texture1D;
            cmapTexture->setImage( osg::get_pointer( image ) );
            set->setTextureAttributeAndModes( 0, osg::get_pointer( cmapTexture ) );
            set->addUniform( new osg::Uniform( "colormap", 0 ) );
        }
        viewer.getCamera()->setClearColor( osg::Vec4( bkR, bkG, bkB, 1.0f ) );
        // add matrix transform to allow for manipulator operations
		
		if( arguments.read( "-manip" ) )
		{
			osg::ref_ptr< osg::Group > root = new osg::Group;
			osg::ref_ptr< osg::MatrixTransform > mt = new osg::MatrixTransform;
			mt->addChild( osg::get_pointer( model ) );
			root->addChild( osg::get_pointer( mt ) );
			root->addChild( CreateManipulator( osg::get_pointer( mt ) ) );
			viewer.setSceneData( osg::get_pointer( root ) );
		}
        else if( arguments.read( "-drawbox" ) )
        {
            osg::ref_ptr< osg::Group > group = new osg::Group;
            osg::ref_ptr< osg::Geode > box = new osg::Geode;
            box->addDrawable( new osg::ShapeDrawable( new osg::Box( osg::Vec3( 0.f, 0.f, 0.f ), boxSizeX, boxSizeY, boxSizeZ ) ) );
            osg::ref_ptr< osg::PolygonMode > polyModeObj = new osg::PolygonMode;
            polyModeObj->setMode(  osg::PolygonMode::FRONT_AND_BACK, osg::PolygonMode::LINE );
            box->getOrCreateStateSet()->setAttributeAndModes( osg::get_pointer( polyModeObj ) );
			box->getOrCreateStateSet()->setAttributeAndModes( CreatePassThroughProgram(), osg::StateAttribute::OVERRIDE );
            group->addChild( osg::get_pointer( box ) );
            group->addChild( osg::get_pointer( model ) );
            viewer.setSceneData( osg::get_pointer( group ) );
        }
		else viewer.setSceneData( osg::get_pointer( model ) );
        // add the stats handler
		viewer.addEventHandler(new osgViewer::StatsHandler);    
        return viewer.run();
    } catch( const std::exception& e )
    {
        std::cerr << std::endl << e.what() << std::endl;
    }
}

// End of source code
