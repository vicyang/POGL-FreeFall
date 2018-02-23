package Points;
use Modern::Perl;
use Time::HiRes qw/time/;

our $g = 9.8;

sub new
{
	my $class = shift;
	my $ref = 
        {
            time => time() , 
            xs => 10.0 + rand(10.0),
            ys => 30.0 + rand(30.0),
            @_ , 
        };
	bless $ref, $class;
    return $ref;
}

sub show_info
{
    my $self = shift;
    printf "%.2f %.2f %.3f\n", $self->{x}, $self->{y}, $self->{time};
}

sub curr_pos
{
    my $self = shift;
    # 速度分量
    my ($vx, $vy) = ( $self->{xs}, $self->{ys} );
    my ($x, $y);

    # 时间差 * 5
    my $t = ( time() - $self->{time} ) *5;
    $x = $self->{x} + $vx * $t;

    # Va * t + 1/2 * g * t^2;
    $y = $self->{y} + $vy * $t - $g /2.0* $t * $t;

    if ( $y <= 0.0 )
    {
        $self->{ys} = -( $self->{ys} - $g * $t ) * 0.8;  # 动力消减
        $self->{xs} *= 0.8;
        $self->{x} = $x;
        $self->{y} = 0.0;        # y 定位到水平线
        $self->{time} = time();  # 更新初始时间
        #say $self->{ys};
    }

    return ( $x, $y );
}

1;