// Populate the sidebar
//
// This is a script, and not included directly in the page, to control the total size of the book.
// The TOC contains an entry for each page, so if each page includes a copy of the TOC,
// the total size of the page becomes O(n**2).
class MDBookSidebarScrollbox extends HTMLElement {
    constructor() {
        super();
    }
    connectedCallback() {
        this.innerHTML = '<ol class="chapter"><li class="chapter-item expanded affix "><a href="project_info/overview.html">Overview</a></li><li class="chapter-item expanded affix "><a href="project_info/ml_project_structure.html">ML project structure</a></li><li class="chapter-item expanded affix "><li class="part-title">Gemma 3n setup</li><li class="chapter-item expanded "><a href="ml_project_setup/model/model.html"><strong aria-hidden="true">1.</strong> Original Model &amp; Tooling Overview</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="ml_project_setup/model/base_model.html"><strong aria-hidden="true">1.1.</strong> Base model</a></li><li class="chapter-item expanded "><a href="ml_project_setup/model/justification.html"><strong aria-hidden="true">1.2.</strong> Justification for Tooling Choices</a></li></ol></li><li class="chapter-item expanded "><a href="ml_project_setup/fune_tuning/fine_tuning.html"><strong aria-hidden="true">2.</strong> Model Fine-Tuning Process</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="ml_project_setup/fune_tuning/dockerized.html"><strong aria-hidden="true">2.1.</strong> The Dockerized Workflow</a></li><li class="chapter-item expanded "><a href="ml_project_setup/fune_tuning/data_curation.html"><strong aria-hidden="true">2.2.</strong> Data Curation and Preprocessing</a></li><li class="chapter-item expanded "><a href="ml_project_setup/fune_tuning/strategy.html"><strong aria-hidden="true">2.3.</strong> Fine-Tuning Strategy: QLoRA</a></li><li class="chapter-item expanded "><a href="ml_project_setup/fune_tuning/hyperparameter.html"><strong aria-hidden="true">2.4.</strong> Hyperparameter Rationale</a></li><li class="chapter-item expanded "><a href="ml_project_setup/fune_tuning/merging.html"><strong aria-hidden="true">2.5.</strong> Model Merging</a></li></ol></li><li class="chapter-item expanded "><a href="ml_project_setup/results/results.html"><strong aria-hidden="true">3.</strong> Results Comparison &amp; Final Model Selection</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="ml_project_setup/results/qualitative.html"><strong aria-hidden="true">3.1.</strong> Qualitative Improvement</a></li><li class="chapter-item expanded "><a href="ml_project_setup/results/safety.html"><strong aria-hidden="true">3.2.</strong> Quantitative Safety Evaluation (GGUF Models)</a></li><li class="chapter-item expanded "><a href="ml_project_setup/results/conclusion.html"><strong aria-hidden="true">3.3.</strong> Conclusion and Final Model Choice</a></li></ol></li><li class="chapter-item expanded "><a href="ml_project_setup/usage/usage.html"><strong aria-hidden="true">4.</strong> Setup &amp; Usage</a></li><li class="chapter-item expanded "><a href="ml_project_setup/notebook_demonstration/notebook_demo.html"><strong aria-hidden="true">5.</strong> Interactive Demonstration Notebook</a></li><li class="chapter-item expanded affix "><li class="part-title">iOS setup</li><li class="chapter-item expanded "><a href="ios_project_setup/inference.html"><strong aria-hidden="true">6.</strong> Inference setup</a></li><li class="chapter-item expanded "><a href="ios_project_setup/app_setup.html"><strong aria-hidden="true">7.</strong> App setup</a></li><li class="chapter-item expanded "><a href="ios_project_setup/publishing.html"><strong aria-hidden="true">8.</strong> Publishing app</a></li></ol>';
        // Set the current, active page, and reveal it if it's hidden
        let current_page = document.location.href.toString().split("#")[0].split("?")[0];
        if (current_page.endsWith("/")) {
            current_page += "index.html";
        }
        var links = Array.prototype.slice.call(this.querySelectorAll("a"));
        var l = links.length;
        for (var i = 0; i < l; ++i) {
            var link = links[i];
            var href = link.getAttribute("href");
            if (href && !href.startsWith("#") && !/^(?:[a-z+]+:)?\/\//.test(href)) {
                link.href = path_to_root + href;
            }
            // The "index" page is supposed to alias the first chapter in the book.
            if (link.href === current_page || (i === 0 && path_to_root === "" && current_page.endsWith("/index.html"))) {
                link.classList.add("active");
                var parent = link.parentElement;
                if (parent && parent.classList.contains("chapter-item")) {
                    parent.classList.add("expanded");
                }
                while (parent) {
                    if (parent.tagName === "LI" && parent.previousElementSibling) {
                        if (parent.previousElementSibling.classList.contains("chapter-item")) {
                            parent.previousElementSibling.classList.add("expanded");
                        }
                    }
                    parent = parent.parentElement;
                }
            }
        }
        // Track and set sidebar scroll position
        this.addEventListener('click', function(e) {
            if (e.target.tagName === 'A') {
                sessionStorage.setItem('sidebar-scroll', this.scrollTop);
            }
        }, { passive: true });
        var sidebarScrollTop = sessionStorage.getItem('sidebar-scroll');
        sessionStorage.removeItem('sidebar-scroll');
        if (sidebarScrollTop) {
            // preserve sidebar scroll position when navigating via links within sidebar
            this.scrollTop = sidebarScrollTop;
        } else {
            // scroll sidebar to current active section when navigating via "next/previous chapter" buttons
            var activeSection = document.querySelector('#sidebar .active');
            if (activeSection) {
                activeSection.scrollIntoView({ block: 'center' });
            }
        }
        // Toggle buttons
        var sidebarAnchorToggles = document.querySelectorAll('#sidebar a.toggle');
        function toggleSection(ev) {
            ev.currentTarget.parentElement.classList.toggle('expanded');
        }
        Array.from(sidebarAnchorToggles).forEach(function (el) {
            el.addEventListener('click', toggleSection);
        });
    }
}
window.customElements.define("mdbook-sidebar-scrollbox", MDBookSidebarScrollbox);
