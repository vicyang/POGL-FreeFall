package Points;
use Modern::Perl;
use Time::HiRes qw/time/;

our $g = 9.8;
our $id = 0;

sub new
{
	my $class = shift;
	my $ref = 
        {
            id => $id++ ,
            time => time() ,
            timeply => 2.0,             #时间倍率
            xs => 10.0 + rand(5.0) ,
            ys => 15.0 + rand(10.0) ,
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

    # 时间差 * 2
    my $t = ( time() - $self->{time} ) * $self->{timeply};

    # y = V0t - 1/2 * gt^2
    $x = $self->{x} + $vx * $t;
    $y = $self->{y} + $vy * $t - $g /2.0* $t * $t;

    if ( $y <= 0.0 )
    {
        # 反向 + 动力消减
        $self->{ys} = -( $self->{ys} - $g * $t ) * (0.8+rand(0.1));
        $self->{xs} *= 0.9;
        
        $self->{x} = $x;
        $self->{y} = 0.0;        # y 定位到水平线
        $y = 0.0;

        if ( abs($self->{ys}) < 2.0) {
            $self->{ys} = 0.0;
        }
        
        $self->{time} = time();  # 更新初始时间

        if ($self->{id} == 1) {
            printf "%d - %.3f %.3f\n", $self->{id}, $self->{ys}, $t
        }
    }

    if ( $x >= $self->{right} or $x <= 0.0 )
    {
        $self->{ys} = $self->{ys} - $g * $t;
        $self->{xs} = -$self->{xs} * 0.9;
        $self->{x} = $x <= 0.0 ? 0.0 : $self->{right};
        $self->{y} = $y;
        $self->{time} = time();  # 更新初始时间
    }

    return ( $x, $y );
}

1;