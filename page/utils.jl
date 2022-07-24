# do not remove this first line
using PkgPage
using ColorSchemes
using Colors

const sc = ColorSchemes.seaborn_colorblind
const n_colors = length(sc)
#
# Feel free to add whatever custom hfun_* or lx_*
# you might want to use in your site here

function hfun_publi(publi_counter)
    counter = globvar(first(publi_counter))
    PkgPage.F.set_var!(PkgPage.F.GLOBAL_VARS, "publi_counter", counter+1)
    """style="border-color:#$(hex(sc[mod1(counter, n_colors)]))" """
end