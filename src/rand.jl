using Random

Random.rand(rng::AbstractRNG, ::Random.SamplerType{Infinite}) = Infinite(rand(rng, Bool))
