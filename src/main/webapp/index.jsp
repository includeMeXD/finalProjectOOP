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

        <!-- 2. ANTI-RACISM RESOURCES SECTION (MIDDLE) -->
        <div class="selection-container mb-4">
            <h2 class="section-title">Anti-Racism Resources</h2>
            <div class="row g-4">
                <!-- Resource 1: Educational Readings -->
                <div class="col-md-4">
                    <div class="resource-card">
                        <div>
                            <h4 class="resource-title">Educational Readings</h4>
                            <p class="resource-desc">
                                Study anti-racist principles and history. Read curated books and essays from historians and anti-racism educators.
                            </p>
                        </div>
                        <a href="https://www.ibramxkendi.com/how-to-be-an-antiracist" target="_blank" class="resource-link">Kendi's Anti-Racist Guide &rarr;</a>
                    </div>
                </div>

                <!-- Resource 2: Civil Rights Support -->
                <div class="col-md-4">
                    <div class="resource-card">
                        <div>
                            <h4 class="resource-title">Advocacy & Legal Defense</h4>
                            <p class="resource-desc">
                                Support organizations leading structural legal reform, defending civil rights, and protecting marginalized communities.
                            </p>
                        </div>
                        <a href="https://www.naacpldf.org" target="_blank" class="resource-link">NAACP Legal Defense Fund &rarr;</a>
                    </div>
                </div>

                <!-- Resource 3: Action Toolkits -->
                <div class="col-md-4">
                    <div class="resource-card">
                        <div>
                            <h4 class="resource-title">Racial Justice Action</h4>
                            <p class="resource-desc">
                                Access racial justice toolkits and guides to practice daily allyship and campaign for equality in your local area.
                            </p>
                        </div>
                        <a href="https://www.aclunc.org/our-work/get-involved/racial-justice-advocacy" target="_blank" class="resource-link">ACLU Racial Justice Guides &rarr;</a>
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
</body>
</html>
