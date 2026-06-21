<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="servlets.GameServlet" %>
<%@ page import="servlets.ScoreRecord" %>
<%
    List<ScoreRecord> leaderboard = (List<ScoreRecord>) request.getAttribute("leaderboard");
    if (leaderboard == null) {
        leaderboard = GameServlet.getScores();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Minority Escape - Setup</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom Cyberpunk Styles -->
    <link href="assets/theme.css" rel="stylesheet">
</head>
<body>
    <div class="container py-5">
        <div class="cyber-header text-center">
            <h1 class="cyber-title">Minority Escape</h1>
            <p class="cyber-subtitle">Setup Game & Leaderboard</p>
        </div>

        <form action="GameServlet?action=start" method="POST">
            <div class="row g-4">
                <!-- Left Side: Config & Character Select -->
                <div class="col-lg-7">
                    <!-- Compact Setup Panel -->
                    <div class="glass-panel mb-3" style="padding: 1.5rem 2rem;">
                        <div class="decor-glow glow-top-right"></div>
                        <div class="d-flex flex-column gap-3">
                            <!-- Player Name Column -->
                            <div class="d-flex flex-column">
                                <label for="playerName" class="form-label-cyber">Runner Name</label>
                                <input type="text" class="input-cyber w-100" id="playerName" name="playerName" placeholder="Enter player name..." value="Runner_1" required>
                            </div>
                            <!-- Map Selection Column -->
                            <div class="d-flex flex-column">
                                <label for="mapTheme" class="form-label-cyber">Map</label>
                                <select class="select-cyber w-100" id="mapTheme" name="mapTheme">
                                    <option value="Virginia Manor">Virginia Manor</option>
                                </select>
                            </div>
                            <!-- Description Column -->
                            <div class="d-flex flex-column">
                                <label class="form-label-cyber">Description</label>
                                <div class="map-description" style="margin-top: 0; padding: 0.75rem 1rem; font-size: 0.85rem; line-height: 1.5;">
                                    <strong>Virginia Manor:</strong> Historically, Virginia was one of the largest states for slaveholdings, hosting a high population of both enslaved people and slaveholders. This map represents the challenging path of moving away from that legacy toward structural equality.
                                </div>
                            </div>
                        </div>
                        
                        <!-- Hidden form inputs for skins -->
                        <input type="hidden" name="runnerSkin" value="Virginia Manor">
                        <input type="hidden" name="chaserSkin" value="Virginia Manor Chaser">
                    </div>

                    <!-- Action Bar (unified layout) -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <a href="GameServlet" class="btn btn-outline-cyber-secondary" style="font-size: 0.9rem; padding: 0.6rem 1.5rem;">&lt; Return to Menu</a>
                        <div class="d-flex gap-3">
                            <button type="button" class="btn btn-outline-cyber-secondary" style="font-size: 0.9rem; padding: 0.6rem 1.5rem;" id="openModalBtn">View Controls</button>
                            <button type="submit" class="btn btn-cyber" style="font-size: 0.95rem; padding: 0.6rem 2rem;">Start running</button>
                        </div>
                    </div>
                </div>

                <!-- Right Side: Leaderboard -->
                <div class="col-lg-5">
                    <div class="glass-panel h-100">
                        <div class="decor-glow glow-top-right"></div>
                        <h3 class="hud-title text-center mb-4">Top Runners</h3>
                        
                        <div class="table-responsive leaderboard-scroll">
                            <table class="leaderboard-table">
                                <thead>
                                    <tr>
                                        <th class="text-center">Rank</th>
                                        <th>Player</th>
                                        <th class="text-end">Score</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        if (leaderboard.isEmpty()) {
                                    %>
                                    <tr>
                                        <td colspan="3" class="text-center text-muted py-4">No escape records available.</td>
                                    </tr>
                                    <%
                                        } else {
                                            int rank = 1;
                                            for (ScoreRecord r : leaderboard) {
                                                String badgeClass = "rank-other";
                                                if (rank == 1) badgeClass = "rank-1";
                                                else if (rank == 2) badgeClass = "rank-2";
                                                else if (rank == 3) badgeClass = "rank-3";
                                    %>
                                    <tr>
                                        <td class="text-center">
                                            <span class="rank-badge <%= badgeClass %>"><%= rank %></span>
                                        </td>
                                        <td>
                                            <div class="fw-bold text-dark"><%= r.getPlayerName() %></div>
                                            <div class="text-muted" style="font-size: 0.75rem;">
                                                <%= r.getRunnerSkin() %> vs <%= r.getChaserSkin() %>
                                            </div>
                                            <div class="text-muted" style="font-size: 0.65rem;">
                                                Theme: <%= r.getMapTheme() %>
                                            </div>
                                        </td>
                                        <td class="text-end fw-bold glow-gold">
                                            <%= r.getScore() %>m
                                        </td>
                                    </tr>
                                    <%
                                                rank++;
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <!-- HOW TO PLAY MODAL -->
    <div class="cyber-modal" id="schematicModal">
        <div class="cyber-modal-content">
            <div class="cyber-modal-header">
                <h4 class="hud-title mb-0 text-dark" style="font-size: 1.25rem;">HOW TO PLAY</h4>
                <button class="close-btn" id="closeModalBtn">&times;</button>
            </div>
            <div class="cyber-modal-body">
                <h5 class="text-dark mb-2" style="font-size: 1.05rem; font-weight: 600;">Game Objective</h5>
                <p class="text-muted mb-4">
                    In "Minority Escape", you run forward through the manor estate grounds. Avoid barriers and ground gaps to stay ahead of the guards chasing you.
                </p>

                <h5 class="text-dark mb-2" style="font-size: 1.05rem; font-weight: 600;">Controls</h5>
                <ul class="text-muted mb-4" style="list-style-type: square; padding-left: 1.2rem;">
                    <li><strong style="color: var(--primary-color);">[ SPACEBAR / UP ARROW / W ]</strong>: Jump over barriers and holes.</li>
                    <li><strong style="color: var(--primary-color);">[ DOWN ARROW / S ]</strong>: Crouch / duck to duck under overhead obstacles or slide.</li>
                </ul>

                <h5 class="text-dark mb-2" style="font-size: 1.05rem; font-weight: 600;">Hazards & Obstacles</h5>
                <ul class="text-muted mb-4" style="list-style-type: square; padding-left: 1.2rem;">
                    <li><strong>Ground Barriers</strong>: Colliding with a barrier triggers a stagger penalty, slowing you down and allowing the guards to catch up.</li>
                    <li><strong>Ground Pits</strong>: Falling through gaps in the ground triggers an instant game over.</li>
                    <li>If the chaser guards catch up to you, the run terminates.</li>
                </ul>
            </div>
            <div class="cyber-modal-footer">
                <button type="button" class="btn btn-menu-action" style="max-width: 120px; font-size: 0.85rem; padding: 0.5rem 1rem;" id="closeModalFooterBtn">Close</button>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle JS CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Map Registry & Interaction Logic -->
    <script>
        // Centralized registry for all maps, descriptions, and skin mappings to make adding maps trivial
        const MAPS_REGISTRY = {
            "Virginia Manor": {
                name: "Virginia Manor",
                description: "<strong>Virginia Manor:</strong> Historically, Virginia was one of the largest states for slaveholdings, hosting a high population of both enslaved people and slaveholders. This map represents the challenging path of moving away from that legacy toward structural equality.",
                runnerSkin: "Virginia Manor",
                chaserSkin: "Virginia Manor Chaser"
            }
            // Add new maps here in the future:
            // "Cyber Highway": {
            //     name: "Cyber Highway",
            //     description: "<strong>Cyber Highway:</strong> A futuristic highway map.",
            //     runnerSkin: "Cyber Punk",
            //     chaserSkin: "Glitch Warden"
            // }
        };

        document.addEventListener('DOMContentLoaded', () => {
            // Modal Elements
            const modal = document.getElementById('schematicModal');
            const openBtn = document.getElementById('openModalBtn');
            const closeBtn = document.getElementById('closeModalBtn');
            const closeFooterBtn = document.getElementById('closeModalFooterBtn');

            const showModal = () => {
                modal.style.display = 'flex';
                document.body.style.overflow = 'hidden';
            };

            const hideModal = () => {
                modal.style.display = 'none';
                document.body.style.overflow = 'auto';
            };

            if (openBtn) openBtn.addEventListener('click', showModal);
            if (closeBtn) closeBtn.addEventListener('click', hideModal);
            if (closeFooterBtn) closeFooterBtn.addEventListener('click', hideModal);

            modal.addEventListener('click', (e) => {
                if (e.target === modal) {
                    hideModal();
                }
            });

            // Map selection and update elements
            const selectEl = document.getElementById('mapTheme');
            const descEl = document.querySelector('.map-description');
            const runnerEl = document.querySelector('input[name="runnerSkin"]');
            const chaserEl = document.querySelector('input[name="chaserSkin"]');

            // Populate Map options from the Registry
            selectEl.innerHTML = "";
            Object.keys(MAPS_REGISTRY).forEach(key => {
                const opt = document.createElement('option');
                opt.value = key;
                opt.textContent = MAPS_REGISTRY[key].name;
                selectEl.appendChild(opt);
            });

            function updateMapDetails(mapKey) {
                const mapInfo = MAPS_REGISTRY[mapKey];
                if (mapInfo) {
                    descEl.innerHTML = mapInfo.description;
                    runnerEl.value = mapInfo.runnerSkin;
                    chaserEl.value = mapInfo.chaserSkin;
                }
            }

            // Sync on selection changes
            selectEl.addEventListener('change', (e) => {
                updateMapDetails(e.target.value);
            });

            // Set default initial details
            if (Object.keys(MAPS_REGISTRY).length > 0) {
                const firstKey = Object.keys(MAPS_REGISTRY)[0];
                selectEl.value = firstKey;
                updateMapDetails(firstKey);
            }
        });
    </script>
</body>
</html>
