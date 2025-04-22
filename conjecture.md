
We know that over the course of an epidemic, the average number of cases per case is 1. This is because the cases that are caused and the cases that cause them are the same cases (modulo some fiddling around with initial conditions). We think of this number as an average of case reproductive numbers R_c.

We have also been looking at variation in the number of cases per case. Following the work of Lloyd-Smith, we think about this variation arising in several ways. Each infector is infected at a particular time, with a particular level of susceptibility. Each infector remains infectious for a particular length of time. These two factors determine expected infectiousness. And each infector infects a random number of individuals (assumed for now to be Poisson with mean given by this expectation).

The law of total variance means that we can separate the variance in R_c into an expectation component and a Poisson component. We tend to think about this using the formalism V = κμ² + μ, where κ is the squared coefficient of variation of the expectation (equivalent to the reciprocal of a gamma or negative-binomial shape parameter, in those special cases). In the particular case of averaging over a whole epidemic, μ=1 and V=κ+1.

UMD post-doc Michael Roswell observed in some simple, strictly SIR-based individual-based models that the variance in R_c seemed always to be close to 2 (corresponding to κ=1), and conjectured that something was going on.

We have now done some simple deterministic simulations, with kind of crude numerics (there are some issues), and it looks like this pattern holds up way better than you might expect, even as the variance inside the expectation shifts quite sharply, see below. We don't yet feel we know whether the strong conjecture (κ=1) is true, but it definitely seems like there is something going on that needs a better explanation than we have.

The shift referred to above concerns two components of the expectation: between-cohort and within-cohort. The within-cohort κ is driven by the exponential distribution of infectiousness durations, and might naively be thought to be equal to 1, which is the κ of the exponential distribution. In fact, the depletion of susceptibles reduces the within-cohort κ: if I am infectious for twice as long as you, my expectation will be less than twice yours. This variation actually decreases quite sharply with R0, and seems to closely match the corresponding (and intuitively sensible) increase in between-cohort variation with R0.

The current simulation is fairly clunky and we haven't really pushed hard to make it very accurate. There is a clear shift, and a clear tendency for the total deterministic variance to be near 1, but it's not clear so far whether it actually is 1; here is a table from a particular set of simulations.

```
   R0      size  sizeProp        mu    within    between     total
1 1.2 0.3165041 1.0090289 0.9962284 0.9867169 0.01179603 0.9985129
2 1.5 0.5828951 1.0001434 0.9975229 0.9392720 0.05841435 0.9976864
3 2.0 0.7960894 0.9990930 0.9980359 0.8318769 0.16404470 0.9959216
4 4.0 0.9792088 0.9990178 1.0019024 0.5056483 0.48259317 0.9882415
5 8.0 0.9986287 0.9989852 1.0288357 0.2779578 0.68743017 0.9653879
```

sizeProp is just the ratio of the observed-to-expected final size as a sanity check. mu near 1 is also a sanity check and you might notice not super sane.

There are several possible ways forward. 

• This may already be understood, and maybe we could find someone who understands it.

• If the strong conjecture is really true, there is probably a nice proof of it, it would be cool to find that.

• We are kind of stuck on the numerics, or maybe just low on patience. There might be a better way to integrate these equations (we can share notes on what we've done so far).

• There's also the possibility that there is numeric analysis to be done. There might be a fundamentally cooler approach to the numerics that would have larger efficiency gains than could be achieved by just being efficient (happy to talk about that, too)

Some thought experiments are also possible. We could imagine doing simulations with fixed infectious periods. This would _eliminate_ within-cohort deterministic variation. The effects on between-cohort deterministic variation are not obvious, but shouldn't be radical. In particular, it should continue to increase with R0 (since the susceptible landscape changes much more with large R0). This means that the constant-variance thing does not apply to general generation distributions. It might be fun to do SEIR simulations, which would preserve within-cohort variation to first order …
