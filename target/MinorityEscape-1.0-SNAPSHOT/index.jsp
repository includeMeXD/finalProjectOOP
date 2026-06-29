<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Minority Escape</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS Styling -->
    <link href="assets/theme.css" rel="stylesheet">
    <style>
        /* Interactive Daily Reflection Styles */
        .reflection-panel {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 16px;
            padding: 2.25rem 2.5rem;
            box-shadow: 0 10px 30px -10px rgba(0, 0, 0, 0.05), 0 1px 3px rgba(0, 0, 0, 0.02);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            position: relative;
            overflow: hidden;
            border-left: 5px solid var(--primary-color);
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .reflection-panel::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(135deg, rgba(79, 70, 229, 0.02) 0%, rgba(124, 58, 237, 0.02) 100%);
            pointer-events: none;
        }
        .reflection-panel:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px -10px rgba(79, 70, 229, 0.1);
        }
        .quote-icon {
            font-size: 3.5rem;
            line-height: 0;
            color: rgba(79, 70, 229, 0.1);
            font-family: 'Outfit', sans-serif;
            position: absolute;
            top: 2.25rem;
            left: 1.5rem;
            user-select: none;
        }
        .quote-text {
            font-size: 1.2rem;
            font-weight: 500;
            font-style: italic;
            line-height: 1.6;
            margin-bottom: 0.75rem;
            color: var(--text-main);
            position: relative;
            z-index: 1;
            padding-left: 1.5rem;
        }
        .quote-author {
            font-family: 'Outfit', sans-serif;
            font-weight: 600;
            color: var(--primary-color);
            text-align: right;
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
        }
        .prompt-box {
            background: rgba(79, 70, 229, 0.03);
            border: 1px dashed rgba(79, 70, 229, 0.15);
            border-radius: 8px;
            padding: 1.25rem;
            margin-bottom: 1.5rem;
        }
        .prompt-label {
            font-family: 'Outfit', sans-serif;
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--secondary-color);
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 0.5rem;
        }
        .prompt-text {
            font-size: 0.95rem;
            color: var(--text-muted);
            line-height: 1.5;
        }
        
        /* Filter Tabs Styling */
        .filter-tabs-container {
            display: flex;
            justify-content: center;
            gap: 0.75rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }
        .filter-tab {
            font-family: 'Outfit', sans-serif;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 0.6rem 1.35rem;
            border-radius: 30px;
            border: 1px solid rgba(0, 0, 0, 0.06);
            background: var(--card-bg);
            color: var(--text-muted);
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.02);
        }
        .filter-tab:hover {
            color: var(--primary-color);
            border-color: rgba(79, 70, 229, 0.25);
            background: rgba(79, 70, 229, 0.03);
            transform: translateY(-1px);
        }
        .filter-tab.active {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: #ffffff;
            border-color: transparent;
            box-shadow: 0 4px 15px rgba(79, 70, 229, 0.2);
        }
        
        /* Resource Badges */
        .resource-badge {
            display: inline-block;
            font-family: 'Outfit', sans-serif;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 3px 10px;
            border-radius: 4px;
            margin-bottom: 0.75rem;
        }
        .badge-book {
            background: rgba(8, 145, 178, 0.08);
            color: var(--accent-color);
        }
        .badge-media {
            background: rgba(124, 58, 237, 0.08);
            color: var(--secondary-color);
        }
        .badge-org {
            background: rgba(79, 70, 229, 0.08);
            color: var(--primary-color);
        }
        
        .resource-col {
            transition: opacity 0.3s ease, transform 0.3s ease;
        }
    </style>
</head>
<body>
    <div class="container d-flex flex-column align-items-center">
        <!-- HERO SECTION -->
        <div class="d-flex flex-column align-items-center justify-content-center" style="min-height: 50vh; width: 100%; margin-top: 5vh; margin-bottom: 5vh;">
            <!-- HEADER -->
            <div class="cyber-header mb-4">
                <h1 class="cyber-title">Minority Escape</h1>
                <p class="cyber-subtitle">Outrun the chase, dodge obstacles, and survive</p>
            </div>

            <!-- DIRECT PLAY GAME SECTION -->
            <div class="text-center">
                <a href="GameServlet?action=setup" class="btn btn-cyber" style="font-size: 1.2rem; padding: 0.9rem 2.5rem;">Play Game</a>
            </div>
        </div>

        <!-- DAILY REFLECTION WIDGET -->
        <div class="selection-container mb-5">
            <div class="reflection-panel">
                <div class="quote-icon">&ldquo;</div>
                <div class="quote-text" id="quoteText">In a racist society, it is not enough to be non-racist, we must be anti-racist.</div>
                <div class="quote-author" id="quoteAuthor">&mdash; Angela Y. Davis</div>
                <div class="prompt-box">
                    <div class="prompt-label">Reflective Prompt</div>
                    <div class="prompt-text" id="promptText">How do you actively practice anti-racism in your daily interactions rather than just holding non-racist beliefs?</div>
                </div>
                <div class="text-center">
                    <button class="btn btn-outline-cyber-secondary" style="font-size: 0.85rem; padding: 0.55rem 1.6rem;" onclick="generateRandomQuote()">Get Another Prompt &rarr;</button>
                </div>
            </div>
        </div>

        <!-- 2. ANTI-RACISM RESOURCES SECTION (MIDDLE) -->
        <div class="selection-container mb-5">
            <h2 class="section-title">Anti-Racism Resources</h2>
            
            <!-- Category Filter Tabs -->
            <div class="filter-tabs-container">
                <button class="filter-tab active" onclick="filterResources('all', this)">Show All</button>
                <button class="filter-tab" onclick="filterResources('books', this)">Books & Readings</button>
                <button class="filter-tab" onclick="filterResources('media', this)">Media & Podcasts</button>
                <button class="filter-tab" onclick="filterResources('orgs', this)">Organizations</button>
            </div>

            <div class="row g-4" id="resourcesGrid">
                <!-- Books -->
                <div class="col-md-4 resource-col" data-category="books">
                    <div class="resource-card">
                        <div>
                            <span class="resource-badge badge-book">Book</span>
                            <h4 class="resource-title">How to Be an Antiracist</h4>
                            <p class="resource-desc">
                                Study anti-racist principles and active policy change. Learn from one of the leading scholars of anti-racism.
                            </p>
                        </div>
                        <a href="https://www.ibramxkendi.com/how-to-be-an-antiracist" target="_blank" class="resource-link">Kendi's Guide &rarr;</a>
                    </div>
                </div>

                <div class="col-md-4 resource-col" data-category="books">
                    <div class="resource-card">
                        <div>
                            <span class="resource-badge badge-book">Book</span>
                            <h4 class="resource-title">The New Jim Crow</h4>
                            <p class="resource-desc">
                                Examine systemic mass incarceration and the structural racial caste systems underpinning modern policies.
                            </p>
                        </div>
                        <a href="https://newjimcrow.com/" target="_blank" class="resource-link">New Jim Crow site &rarr;</a>
                    </div>
                </div>

                <div class="col-md-4 resource-col" data-category="books">
                    <div class="resource-card">
                        <div>
                            <span class="resource-badge badge-book">Book</span>
                            <h4 class="resource-title">So You Want to Talk About Race</h4>
                            <p class="resource-desc">
                                A comprehensive guide designed to navigate discussions about race, intersectionality, and privilege.
                            </p>
                        </div>
                        <a href="https://www.ijeomaoluo.com/" target="_blank" class="resource-link">Oluo's site &rarr;</a>
                    </div>
                </div>

                <!-- Podcasts & Media -->
                <div class="col-md-4 resource-col" data-category="media">
                    <div class="resource-card">
                        <div>
                            <span class="resource-badge badge-media">Podcast</span>
                            <h4 class="resource-title">Code Switch</h4>
                            <p class="resource-desc">
                                A weekly NPR show hosted by journalists of color exploring how race impacts politics, history, and pop culture.
                            </p>
                        </div>
                        <a href="https://www.npr.org/sections/codeswitch/" target="_blank" class="resource-link">Listen on NPR &rarr;</a>
                    </div>
                </div>

                <div class="col-md-4 resource-col" data-category="media">
                    <div class="resource-card">
                        <div>
                            <span class="resource-badge badge-media">Audio Series</span>
                            <h4 class="resource-title">1619</h4>
                            <p class="resource-desc">
                                An audio series examining the foundational role slavery played in America's history and economic structures.
                            </p>
                        </div>
                        <a href="https://www.nytimes.com/2020/01/23/podcasts/1619-podcast.html" target="_blank" class="resource-link">Listen on NYT &rarr;</a>
                    </div>
                </div>

                <div class="col-md-4 resource-col" data-category="media">
                    <div class="resource-card">
                        <div>
                            <span class="resource-badge badge-media">Podcast</span>
                            <h4 class="resource-title">Seeing White</h4>
                            <p class="resource-desc">
                                A multi-part documentary series exploring the history and socio-cultural creation of the concept of whiteness.
                            </p>
                        </div>
                        <a href="https://www.sceneonradio.org/seeing-white/" target="_blank" class="resource-link">Listen on Scene on Radio &rarr;</a>
                    </div>
                </div>

                <!-- Organizations -->
                <div class="col-md-4 resource-col" data-category="orgs">
                    <div class="resource-card">
                        <div>
                            <span class="resource-badge badge-org">Organization</span>
                            <h4 class="resource-title">NAACP Legal Defense Fund</h4>
                            <p class="resource-desc">
                                Support the leading civil rights organization fighting for structural legal reform and protecting marginalized groups.
                            </p>
                        </div>
                        <a href="https://www.naacpldf.org" target="_blank" class="resource-link">NAACP LDF &rarr;</a>
                    </div>
                </div>

                <div class="col-md-4 resource-col" data-category="orgs">
                    <div class="resource-card">
                        <div>
                            <span class="resource-badge badge-org">Organization</span>
                            <h4 class="resource-title">Equal Justice Initiative</h4>
                            <p class="resource-desc">
                                Contribute to challenging racial injustice, ending mass incarceration, and protecting human rights.
                            </p>
                        </div>
                        <a href="https://eji.org/" target="_blank" class="resource-link">Explore EJI &rarr;</a>
                    </div>
                </div>

                <div class="col-md-4 resource-col" data-category="orgs">
                    <div class="resource-card">
                        <div>
                            <span class="resource-badge badge-org">Organization</span>
                            <h4 class="resource-title">Anti-Defamation League</h4>
                            <p class="resource-desc">
                                Defend civil rights and battle hate speech, bigotry, extremism, and discrimination in all forms.
                            </p>
                        </div>
                        <a href="https://www.adl.org/" target="_blank" class="resource-link">Visit ADL &rarr;</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- 3. ABOUT PAGE SECTION (BOTTOM) -->
        <div class="selection-container mb-5">
            <h2 class="section-title">About the Game</h2>
            <div class="about-panel">
                <p>
                    <strong>Minority Escape</strong> is a reflective platform runner that metaphorically represents the constant effort required to navigate systemic barriers. As the runner progresses, ground barriers trigger staggers, and pits require precise jumps, illustrating how structural friction decelerates advancement and demands persistent resilience.
                </p>
                <p>
                    This game is built to highlight systemic bias and promote equity, using gameplay mechanics to symbolize social and structural challenges. We encourage players to explore the educational resources above to learn how to actively dismantle these real-world barriers.
                </p>
            </div>
        </div>

        <!-- TELEMETRY FOOTER -->
        <div class="telemetry-row mb-4">
            &copy; 2026 Minority Escape // Connection: Secure // Status: Active
        </div>
    </div>

    <!-- Bootstrap Bundle JS CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Interactive Logic Script -->
    <script>
        // Quotes and Prompts Registry
        const QUOTES_REGISTRY = [
            {
                quote: "In a racist society, it is not enough to be non-racist, we must be anti-racist.",
                author: "Angela Y. Davis",
                prompt: "How do you actively practice anti-racism in your daily interactions rather than just holding non-racist beliefs?"
            },
            {
                quote: "The beauty of anti-racism is that you don't have to be free of racism to be an anti-racist. Anti-racism is the commitment to fight racism wherever you find it, including in yourself.",
                author: "Ijeoma Oluo",
                prompt: "What personal biases have you noticed in yourself, and what active steps are you taking to address them?"
            },
            {
                quote: "History is not the past. It is the present. We carry our history with us. We are our history.",
                author: "James Baldwin",
                prompt: "How do historical policies (like redlining) continue to shape the socioeconomic landscape of your neighborhood today?"
            },
            {
                quote: "No one is born hating another person because of the color of his skin, or his background, or his religion. People must learn to hate, and if they can learn to hate, they can be taught to love.",
                author: "Nelson Mandela",
                prompt: "In what ways can we educate ourselves and younger generations to recognize and dismantle prejudice before it takes root?"
            },
            {
                quote: "We must use our time creatively, in the knowledge that the time is always ripe to do right.",
                author: "Martin Luther King Jr.",
                prompt: "What is one small, immediate action you can take today to support structural equality in your community?"
            }
        ];

        let currentQuoteIndex = 0;

        function generateRandomQuote() {
            let nextIndex = currentQuoteIndex;
            // Prevent getting the same quote twice in a row
            while (nextIndex === currentQuoteIndex && QUOTES_REGISTRY.length > 1) {
                nextIndex = Math.floor(Math.random() * QUOTES_REGISTRY.length);
            }
            currentQuoteIndex = nextIndex;
            const quote = QUOTES_REGISTRY[currentQuoteIndex];

            const qText = document.getElementById('quoteText');
            const qAuth = document.getElementById('quoteAuthor');
            const pText = document.getElementById('promptText');

            // Fade transition
            [qText, qAuth, pText].forEach(el => {
                el.style.opacity = '0';
                el.style.transition = 'opacity 0.25s ease';
            });

            setTimeout(() => {
                qText.textContent = quote.quote;
                qAuth.innerHTML = "&mdash; " + quote.author;
                pText.textContent = quote.prompt;

                [qText, qAuth, pText].forEach(el => {
                    el.style.opacity = '1';
                });
            }, 250);
        }

        // Initialize with a random quote on first load
        document.addEventListener('DOMContentLoaded', () => {
            currentQuoteIndex = Math.floor(Math.random() * QUOTES_REGISTRY.length);
            const quote = QUOTES_REGISTRY[currentQuoteIndex];
            document.getElementById('quoteText').textContent = quote.quote;
            document.getElementById('quoteAuthor').innerHTML = "&mdash; " + quote.author;
            document.getElementById('promptText').textContent = quote.prompt;
        });

        // Filterable Resources Logic
        function filterResources(category, btn) {
            const cards = document.querySelectorAll('.resource-col');
            const tabs = document.querySelectorAll('.filter-tab');
            
            tabs.forEach(t => t.classList.remove('active'));
            btn.classList.add('active');

            cards.forEach(card => {
                const itemCat = card.getAttribute('data-category');
                if (category === 'all' || itemCat === category) {
                    card.classList.remove('d-none');
                    // Reset opacity for transition
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(8px)';
                    card.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
                    setTimeout(() => {
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                    }, 50);
                } else {
                    card.classList.add('d-none');
                }
            });
        }
    </script>
</body>
</html>
