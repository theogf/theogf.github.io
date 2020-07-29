### A Pluto.jl notebook ###
# v0.10.6

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 052533ec-c4ff-11ea-3cd2-57de775ca6da
using AugmentedGaussianProcesses # Automatically export AGP as a shortcut

# ╔═╡ 3814e536-c4ff-11ea-2b48-2be4a912ba6d
using Plots, Distributions, PlutoUI # Some needed libraries

# ╔═╡ 2deacd82-c501-11ea-3620-11853f9dd4ce
pyplot(); default(legend = false, lw = 3.0)

# ╔═╡ 2b26b41a-c6b4-11ea-10e6-8d44d5bcc9ec
logistic(x) = AGP.logistic.(x)

# ╔═╡ 91f6fb16-c4ff-11ea-07c2-3722a3b6a160
begin
	AGP_l = Dict("studentt" => StudentTLikelihood(4.0), "laplace" => LaplaceLikelihood(4.0), "logistic" => LogisticLikelihood());
	dist_l = Dict("studentt" => f -> LocationScale(f, 0.1, TDist(4.0)), "laplace" => f -> Laplace(f, 4.0), "logistic" => f -> Bernoulli(AGP.logistic(f)));
end

# ╔═╡ 7f2844e2-c4ff-11ea-37a5-695a0b62e4e4
f_target(x) = sinc(x); # True underlying function

# ╔═╡ d99b570e-c500-11ea-318c-8388419a3906
@bind likelihood Select(["studentt" => "Student-T", "laplace" => "Laplace", "logistic" => "Logistic"]) # Selection of the likelihood

# ╔═╡ 3e35b094-c4ff-11ea-361c-671f2ebe0965
begin
	N = 100
	x = rand(Uniform(-10, 10), N)
	xtest = range(-10, 10, length = 200)
	y = rand.(dist_l[likelihood].(f_target.(x))) # Generate some toy dataset
end

# ╔═╡ f89c91e2-c500-11ea-0045-73b78ba88429
scatter(x, y)

# ╔═╡ 46e49654-c501-11ea-334f-7bd9a2fc5e3d
m = VGP(x, y, SqExponentialKernel(), AGP_l[likelihood], AnalyticVI())

# ╔═╡ 6ce1c6d8-c501-11ea-29f5-29015df1bd1d
train!(m, 10)

# ╔═╡ 70b346ce-c501-11ea-0e4b-8f4d6315d825
f_pred = predict_f(m, xtest)

# ╔═╡ 96da1256-c501-11ea-2a3e-6531d846d0f7
y_pred = predict_y(m, xtest)

# ╔═╡ 9d126db2-c501-11ea-0357-f1af32d2a387
m_y, sig_y = proba_y(m, xtest)

# ╔═╡ b351cdf2-c501-11ea-1454-d156c8247763
begin
	plot(xtest, f_target)
	scatter!(x, y)
	plot!(xtest, f_pred)
	plot!(xtest, m_y, ribbon = sqrt.(sig_y))
end

# ╔═╡ 2801d0ca-c5d9-11ea-297a-611286b68d2e
mcmc_m = MCGP(x, y, SqExponentialKernel(), AGP_l[likelihood], GibbsSampling())

# ╔═╡ 4f177354-c5d9-11ea-3f2e-e96da482096d
samples = AGP.sample(mcmc_m, 300, cat_samples = false);

# ╔═╡ c3133b8e-c5df-11ea-3f4d-5d7c8fe18625
samples_f = collect(eachcol(first(AGP._sample_f(mcmc_m, reshape(xtest, :, 1)))))

# ╔═╡ d9431b0c-c5df-11ea-2b26-63fa07d3bd80
begin
	if likelihood == "logistic"
		plot(xtest, logistic.(samples_f), alpha = 0.05, lw = 1.0, color = :black)
	else
		plot(xtest, samples_f, alpha = 0.05, lw = 1.0, color = :black)
	end
	plot!(xtest, f_target, color = 1)
	scatter!(x, y, color = 2)
end

# ╔═╡ Cell order:
# ╠═052533ec-c4ff-11ea-3cd2-57de775ca6da
# ╠═3814e536-c4ff-11ea-2b48-2be4a912ba6d
# ╠═2deacd82-c501-11ea-3620-11853f9dd4ce
# ╠═2b26b41a-c6b4-11ea-10e6-8d44d5bcc9ec
# ╠═91f6fb16-c4ff-11ea-07c2-3722a3b6a160
# ╠═7f2844e2-c4ff-11ea-37a5-695a0b62e4e4
# ╠═3e35b094-c4ff-11ea-361c-671f2ebe0965
# ╠═f89c91e2-c500-11ea-0045-73b78ba88429
# ╠═46e49654-c501-11ea-334f-7bd9a2fc5e3d
# ╠═6ce1c6d8-c501-11ea-29f5-29015df1bd1d
# ╠═70b346ce-c501-11ea-0e4b-8f4d6315d825
# ╠═96da1256-c501-11ea-2a3e-6531d846d0f7
# ╠═9d126db2-c501-11ea-0357-f1af32d2a387
# ╠═d99b570e-c500-11ea-318c-8388419a3906
# ╠═b351cdf2-c501-11ea-1454-d156c8247763
# ╠═2801d0ca-c5d9-11ea-297a-611286b68d2e
# ╠═4f177354-c5d9-11ea-3f2e-e96da482096d
# ╠═c3133b8e-c5df-11ea-3f4d-5d7c8fe18625
# ╠═d9431b0c-c5df-11ea-2b26-63fa07d3bd80
