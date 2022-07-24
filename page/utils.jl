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

function hfun_fill_code(links)
    paper_link = first(links)
    elements = """<div>
        <a href="$paper_link"><b>Paper: </b><img style="height:2em" src="assets/graduation.svg"/></a>
    """
    if length(links) > 1
        code_link = links[2]
        elements *= """ <a href="$code_link"><b>Code: </b><img style="height:1.5em" src="assets/github_logo.png"/></a>
        """
    end
    if length(links) > 2
        youtube_link = links[3]
        elements *= """ <a href="$youtube_link"><b>Video: </b><img style="height:2em" src="assets/watch video.svg"/></a>"""
    end
    elements *= "</div>" 
end