package Points;
use Modern::Perl;
use Time::HiRes qw/time/;

sub new
{
	my $class = shift;
	my $ref = 
        {
            time => time() , 
            xs => 20.0 + rand(10.0),
            ys => 50.0 + rand(10.0),
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
    my $g = 9.8;
    my $t = ( time() - $self->{time} ) *5;
    #printf "%.5f\n", $t;
    $x = $self->{x} + $vx * $t;
    # Va * t + 1/2 * g * t^2;
    $y = $self->{y} + $vy * $t - $g /2.0* $t * $t;

    #printf "%.2f %.2f %.3f\n", $x, $y, $t;

    return ( $x, $y );
}

1;