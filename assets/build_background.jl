using CairoMakie
using AbstractGPsMakie
using AbstractGPs
import CairoMakie.Makie.ColorSchemes.seaborn_colorblind6 as sc
using FileIO
using ImageMagick
xtest = 0:0.01:2

set_theme!(
    palette=(color=sc,),
    patchcolor=(Set1_4[2], 0.2),
)
gp = GP(PeriodicKernel(;r=[100.0]))
gp = GP(SqExponentialKernel() ∘ ScaleTransform(1) ∘ PeriodicTransform(0.5))
x = [0.1, 0.9]
gpx = gp(x, 0.001)
y = rand(gpx)
post_gp = posterior(gpx, y)
fig = Figure(figure_padding=0, resolution=(600, 200))
ax = Axis(fig[1,1])
plot!(ax, xtest, post_gp; bandscale= 3, color=(sc[1], 0.2), linewidth=0.0)
tightlimits!(ax, Left(), Right())

hidedecorations!(ax)
hidespines!(ax)
resize_to_layout!(fig)

nsamples = 10
samples = gpsample!(xtest, post_gp; samples = nsamples, color=sc[3])
scatter!(x, y)

fig
##
path_gif = joinpath(@__DIR__, "original_anim.mp4")
@elapsed record(fig, path_gif, 0:0.01:2) do x
    samples.orbit[] = x
end
##
using DitherPunk
stream = VideoIO.openvideo(path_gif)
my_gif = load(path_gif)
@show @elapsed new_gif = dither.(my_gif, Ref(ClusteredDots()))
path_new_gif = joinpath(@__DIR__, "dithered_anim.gif")
# save(path_new_gif, new_gif; framerate=20)
save(path_new_gif, cat(new_gif...; dims=3))