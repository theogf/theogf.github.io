using DitherPunk
using Images
using Images.ImageTransformations

img = dither(imresize(RGB.(load("_assets/profile.png")), ratio=2/3), Bayer())

dims = size(img)
C = collect(dims .÷ 2)
r = 15

kernel(u) = exp(-u / r^2)
kernel(u) = max(0, 70/81 * (1 - abs(u)^3)^3)

indices = collect.(collect(Base.product(range.(1, dims, step=1)...)))
alpha = kernel.(norm.((indices .- Ref(C)) ./ Ref(C), 2))
img = RGBA.(img, alpha) 

save("_assets/dithered_profile.png", img)
img