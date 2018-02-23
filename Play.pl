use feature 'state';
use IO::Handle;
use List::Util qw/max min/;
use Time::HiRes qw/sleep time/;
use OpenGL qw/ :all /;
use OpenGL::Config;
use Points;

STDOUT->autoflush(1);

BEGIN
{
    our $WinID;
    our $HEIGHT = 500;
    our $WIDTH  = 500;
    our ($show_w, $show_h) = (500,500);
    our ($half_w, $half_h) = ($show_w/2.0, $show_h/2.0);

    # 初速度
    our ($vx, $vy) = ( 20.0, 50.0);
   	our ($x, $y) = (0.0, 0.0);
   	our $g = 9.8;
   	our $ta = time();

    our @dots;
    for ( 0 .. 100 )
    {
        push @dots, Points->new( x => $_ , y => $_  );
    }
}

&main();

sub display
{
	my $t;
	state $iter = 0.0;
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    my ($x, $y);

    glBegin(GL_POINTS);
    for my $dot ( @dots )
    {
        ($x, $y) = $dot->curr_pos();
        glVertex3f( $x, $y, 0.0);
    }
    glEnd();

    glutSwapBuffers();
}

sub idle 
{
    sleep 0.02;
    glutPostRedisplay();
}

sub init
{
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glEnable(GL_DEPTH_TEST);
    glPointSize(2.0);
}

sub reshape
{
    state $fa = 100.0;
    my ($w, $h) = (shift, shift);
    my ($max, $min) = (max($w, $h), min($w, $h) );

    glViewport(0, 0, $min, $min);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0.0, $show_w, -$half_h, $half_h, 0.0, $fa*2.0); 
    #glFrustum(-100.0, $WIDTH-100.0, -100.0, $HEIGHT-100.0, 800.0, $fa*5.0); 
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(0.0,0.0,$fa, 0.0,0.0,0.0, 0.0,1.0, $fa);
}

sub hitkey
{
    our $WinID;
    my $k = lc(chr(shift));
    if ( $k eq 'q') { quit() }
}

sub quit
{
    glutDestroyWindow( $WinID );
    exit 0;
}

sub main
{
    our $MAIN;

    glutInit();
    glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH );
    glutInitWindowSize($WIDTH, $HEIGHT);
    glutInitWindowPosition(100, 100);
    $WinID = glutCreateWindow("Free-fall");
    
    &init();
    glutDisplayFunc(\&display);
    glutReshapeFunc(\&reshape);
    glutKeyboardFunc(\&hitkey);
    glutIdleFunc(\&idle);
    glutMainLoop();
}