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
            zs => 15.0 + rand(10.0) ,
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
    my ($vx, $vy, $vz) = ( $self->{xs}, $self->{ys}, $self->{zs} );
    my ($x, $y, $z);

    # 时间差 * 2
    my $t = ( time() - $self->{time} ) * $self->{timeply};

    # y = V0t - 1/2 * gt^2
    $x = $self->{x} + $vx * $t;
    $y = $self->{y} + $vy * $t - $g /2.0* $t * $t;
    $z = $self->{z} + $vz * $t;

    if ( $y <= $self->{bottom} )
    {
        # 反向 + 动力消减
        $self->{ys} = -( $self->{ys} - $g * $t ) * (0.8+rand(0.1));
        $self->{xs} *= 0.8;
        $self->{zs} *= 0.8;
        
        $self->{z} = $z;
        $self->{x} = $x;
        $self->{y} = $self->{bottom};        # y 定位到水平线
        $y = $self->{bottom};

        # 速度小于 5.0 时清零
        if ( abs($self->{ys} ) < 2.0) {
            $self->{ys} = 0.0;
        }
        
        $self->{time} = time();  # 更新初始时间

        if ($self->{id} == 1) {
            printf "%d - %.3f %.3f\n", $self->{id}, $self->{ys}, $t
        }
    }

    if ( $x <= $self->{left} or $x >= $self->{right} )
    {
        $self->{xs} = -$self->{xs} * 0.8;
        $self->{ys} = $self->{ys} - $g * $t;
        $self->{zs} = $self->{zs} * 0.8;

        $self->{x} = $x <= $self->{left} ? $self->{left} : $self->{right};
        $self->{y} = $y;
        $self->{z} = $z;
        $self->{time} = time();  # 更新初始时间
    }

    if ( $z <= $self->{back} or $z >= $self->{front} )
    {
        $self->{zs} = -$self->{zs} * 0.8;
        $self->{xs} = $self->{xs} * 0.8;
        $self->{ys} = $self->{ys} - $g * $t;

        $self->{z} = $z <= $self->{back} ? $self->{back} : $self->{front};
        $self->{y} = $y;
        $self->{x} = $x;
        $self->{time} = time();  # 更新初始时间
    }

    return ( $x, $y, $z );
}

1;