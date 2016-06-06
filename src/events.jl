export Event, detect, haspassed, gettime
export PericenterEvent, ApocenterEvent, StartEvent, EndEvent, ImpactEvent
export Update, apply!
export ImpulsiveManeuver, Stop
export PropagatorAbort, Abort

abstract Event
abstract Update

type PropagatorAbort <: Exception
    msg::AbstractString
end
Base.show(io::IO, err::PropagatorAbort) = print(io, err.msg)

gettime(::Event) = Nullable{Float64}()

type StartEvent <: Event
    update::Update
end

gettime(::StartEvent) = Nullable(0.0)

type EndEvent <: Event
    update::Update
end

gettime(::EndEvent) = Nullable(-1.0)

type PericenterEvent <: Event
    update::Update
end

function haspassed(::PericenterEvent, told, t, yold, y, p)
    new = keplerian(y, μ(p.center))[6]
    old = keplerian(yold, μ(p.center))[6]
    sign(new-π) != sign(old-π) && (old < π/2 < new || new < π/2 < old)
end

function detect(t, contd, p, ::PericenterEvent)
    y = Float64[contd(i, t) for i = 1:6]
    ano = keplerian(y, μ(p.center))[6]
    ano = ano > π ? ano - 2π : ano
    return ano
end

type ApocenterEvent <: Event
    update::Update
end

function haspassed(::ApocenterEvent, told, t, yold, y, p)
    new = keplerian(y, μ(p.center))[6]
    old = keplerian(yold, μ(p.center))[6]
    sign(new-π) != sign(old-π) && new > π/2 && old > π/2
end

function detect(t, contd, p, ::ApocenterEvent)
    y = Float64[contd(i, t) for i = 1:6]
    ano = keplerian(y, μ(p.center))[6]
    return ano - π
end

type ImpactEvent <: Event
    update::Update
end

function haspassed(::ImpactEvent, told, t, yold, y, p)
    r = norm(y[1:3]) - mean_radius(p.center)
    r <= 0.0
end

function detect(t, contd, p, ::ImpactEvent)
    y = Float64[contd(i, t) for i = 1:3]
    norm(y[1:3]) - mean_radius(p.center)
end

type ImpulsiveManeuver <: Update
    Δv::Vector{Float64}
end

function apply!(man::ImpulsiveManeuver, t, y, p)
    m = rotation_matrix(RAC, GCRF, y)
    y[4:6] += m*man.Δv
end

type Stop <: Update
end

function apply!(st::Stop, t, y, p)
    p.stop = true
end

type Abort <: Update
end

function apply!(st::Abort, t, y, p)
    throw(PropagatorAbort("Propagation aborted at t=$t."))
end
