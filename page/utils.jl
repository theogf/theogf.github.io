# do not remove this first line
using PkgPage
using ColorSchemes
using Colors
using YAML

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

function hfun_publications()
    pubs = YAML.load_file("_assets/list_publications.yml")
    content = ""
    pub_counter = 1
    for pub in pubs
        new_pub = ""
        new_pub *= """
        <div class="publi" style="border-color:#$(hex(sc[mod1(pub_counter, n_colors)]))">
            <div class="publi-header">
                <h5><b><a href=$(pub["paper-link"])>$(pub["title"])</a></b></h5>
        """
        new_pub *= if haskey(pub, "journal-link")
            string("""<a href=$(pub["journal-link"])> $(pub["journal"]) </a>""")
        else
            pub["journal"]
        end
        new_pub *= "&nbsp;"
        new_pub *= pub["authors"]
        new_pub *= """
            <div class="publi-img-text">
                <div class="publi-thumbnail">
                    <a href="$(get(pub, "link-figure", ""))" data-lightbox="$(pub["title"])" data-title="$(pub["title"])">
                        <img class="publi-img" src=$(get(pub, "link-figure", ""))> 
                    </a>
                </div>
                <div class="publi-abstract"> 
                $(pub["abstract"]) 
                </div>
            </div>
        """
        new_pub *= "</div>"
        new_pub *= fill_links(pub)
        new_pub *= "</div>"
        
        content *= new_pub
        pub_counter += 1
    end
    content
end


function fill_links(pub)
    content = "<div>"
    if haskey(pub, "paper-link")
        content *= """
        <a href=$(pub["paper-link"])><b>Paper: </b><img style="height:2em" src="assets/graduation.svg"/></a>
        """
    end
    if haskey(pub, "code-link")
        content *= """
            <a href=$(pub["code-link"])><b>Code: </b><img style="height:1.5em" src="assets/github_logo.png"/></a>
        """
    end
    if haskey(pub, "video-link")
        content *= """
            <a href=$(pub["video-link"])><b>Video: </b><img style="height:2em" src="assets/watch video.svg"/></a>
        """
    end
    content *= "</div>"
end