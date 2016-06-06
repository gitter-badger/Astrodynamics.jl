@testset "Events" begin
    mu = μ(Earth)
    p = ODE()
    # Prograde
    rp0 = [-2342.136670126566,-2856.9259859483604,4777.266939986499]
    vp0 = [6.0579393617214095,6.335432612493015,6.643682050248055]
    rp1 = [-2220.1446568765923,-2729.1984251946155,4908.395190394116]
    vp1 = [6.140525941928983,6.436552836929808,6.468351846987753]
    ra0 = [25021.708150993607,30635.960949601755,-53102.962324087945]
    va0 = [-0.5559262753378653,-0.5820026447940332,-0.5986590782336557]
    ra1 = [25010.582755919266,30624.312485596525,-53114.92092328085]
    va1 = [-0.5566131811821589,-0.5828437024206758,-0.597200786329596]
    @test haspassed(PericenterEvent(ImpulsiveManeuver(ones(3))), 0.0, 0.0, [rp0; vp0], [rp1; vp1], p) == true
    @test haspassed(ApocenterEvent(ImpulsiveManeuver(ones(3))), 0.0, 0.0, [ra0; va0], [ra1; va1], p) == true
    @test haspassed(PericenterEvent(ImpulsiveManeuver(ones(3))), 0.0, 0.0, [ra0; va0], [ra1; va1], p) == false
    @test haspassed(ApocenterEvent(ImpulsiveManeuver(ones(3))), 0.0, 0.0, [rp0; vp0], [rp1; vp1], p) == false
    # Retrograde
    rp0 = [-6018.471046687208,465.13013820736745,177.67920909747642]
    vp0 = [0.9453096897577892,10.955372197035555,0.24709612986091817]
    rp1 = [-5997.388465706293,684.0427662367711,182.55621599607503]
    vp1 = [1.1628212095997874,10.934569827904234,0.2405751352760357]
    ra0 = [65886.96611997804,-6291.224283226328,-1975.039801000465]
    va0 = [-0.09522960990164073,-0.9983032371852885,-0.0222657165437527]
    ra1 = [65885.04343638303,-6311.188618666875,-1975.484572974316]
    va1 = [-0.09703874080166261,-0.9981302155043381,-0.022211478805857457]
    @test haspassed(PericenterEvent(ImpulsiveManeuver(ones(3))), 0.0, 0.0, [rp0; vp0], [rp1; vp1], p) == true
    @test haspassed(ApocenterEvent(ImpulsiveManeuver(ones(3))), 0.0, 0.0, [ra0; va0], [ra1; va1], p) == true
    @test haspassed(PericenterEvent(ImpulsiveManeuver(ones(3))), 0.0, 0.0, [ra0; va0], [ra1; va1], p) == false
    @test haspassed(ApocenterEvent(ImpulsiveManeuver(ones(3))), 0.0, 0.0, [rp0; vp0], [rp1; vp1], p) == false
end
