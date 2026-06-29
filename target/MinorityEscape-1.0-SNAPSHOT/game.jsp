<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String runnerSkin = (String) session.getAttribute("runnerSkin");
    String chaserSkin = (String) session.getAttribute("chaserSkin");
    String mapTheme = (String) session.getAttribute("mapTheme");
    String playerName = (String) session.getAttribute("playerName");

    if (runnerSkin == null) runnerSkin = "Cyber Punk";
    if (chaserSkin == null) chaserSkin = "Glitch Warden";
    if (mapTheme == null) mapTheme = "Virginia Manor";
    if (playerName == null) playerName = "Runner_0x9F";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Minority Escape - Gameplay</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom Styles -->
    <link href="assets/theme.css" rel="stylesheet">
</head>
<body>
    <div class="game-container">
        <div class="cyber-deck" id="deck" style="padding: 24px;">
            <div class="row g-4 align-items-stretch">
                <!-- Left Sidebar: HUD Info -->
                <div class="col-md-3">
                    <div class="glass-panel" style="padding: 1.5rem; height: 100%; display: flex; flex-direction: column; gap: 1.75rem; justify-content: flex-start; border: 1px solid var(--card-border);">
                        <div>
                            <div class="hud-label">Runner Name</div>
                            <div class="hud-value"><%= playerName %></div>
                        </div>
                        <div>
                            <div class="hud-label">Threat Level</div>
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <div class="threat-container" style="width: 100%;">
                                    <div class="threat-fill" id="threatFill"></div>
                                </div>
                            </div>
                            <div class="fw-bold text-dark text-end" id="threatPercent" style="font-size: 0.9rem;">0%</div>
                        </div>
                        <div>
                            <div class="hud-label">Distance Run</div>
                            <div class="hud-value glow-gold" id="hudScore" style="font-size: 1.5rem;">0m</div>
                        </div>
                        <div class="mt-auto pt-3" style="border-top: 1px solid rgba(0,0,0,0.06);">
                            <div class="hud-label">Map</div>
                            <div class="badge-cyber w-100 text-center mb-2" style="display: block; font-size: 0.8rem; padding: 6px;"><%= mapTheme %></div>
                            <div class="badge-cyber w-100 text-center" id="speedIndicator" style="display: block; font-size: 0.8rem; padding: 6px; border-color: var(--secondary-color); color: var(--secondary-color);">SPEED: 1.0x</div>
                        </div>
                    </div>
                </div>

                <!-- Right Side: Game Window -->
                <div class="col-md-9 d-flex flex-column">
                    <div class="canvas-wrapper h-100" style="position: relative; flex-grow: 1;">
                        <!-- GAME OVER INTERACTIVE OVERLAY -->
                        <div class="game-over-overlay" id="gameOverOverlay">
                            <div class="game-over-title">Game Over</div>
                            <div class="game-over-stats">
                                Runner: <span class="glow-gold"><%= playerName %></span><br>
                                Distance Run: <span class="glow-orange" id="finalScoreText">0m</span><br>
                                Game Map: <span class="text-warning"><%= mapTheme %></span>
                            </div>
                            <form class="game-over-form" action="GameServlet?action=submitScore" method="POST">
                                <input type="hidden" name="score" id="formScore" value="0">
                                <div class="form-group">
                                    <label class="form-label-cyber d-block text-center mb-2" style="font-size: 0.8rem; font-family: 'Outfit';">Confirm name for leaderboard</label>
                                    <input type="text" class="game-over-input" name="playerName" value="<%= playerName %>" placeholder="Your Name" required>
                                </div>
                                <button type="submit" class="game-over-btn">Submit Score</button>
                            </form>
                        </div>

                        <!-- Canvas element -->
                        <canvas id="gameCanvas" width="800" height="400" style="width: 100%; height: auto; display: block; border-radius: 12px;"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Gameplay JS Engine -->
    <script>
        const RUNNER_SKIN = "<%= runnerSkin %>";
        const CHASER_SKIN = "<%= chaserSkin %>";
        const MAP_THEME = "<%= mapTheme %>";

        // Dynamic Asset Preloading Helper - normalizes names to fit filenames (e.g. "Virginia Manor" -> "VirginiaManor")
        const cleanMapName = MAP_THEME.replace(/[^a-zA-Z0-9]/g, '');
        const cleanRunnerName = RUNNER_SKIN.replace(/[^a-zA-Z0-9]/g, '');
        const cleanChaserName = CHASER_SKIN.replace(/[^a-zA-Z0-9]/g, '');

        // Preload custom map images
        const mapImg1 = new Image();
        mapImg1.src = "assets/" + cleanMapName + "Map1.png";
        const mapImg2 = new Image();
        mapImg2.src = "assets/" + cleanMapName + "Map2.png";

        // Preload runner sprites
        const runnerRun1 = new Image();
        runnerRun1.src = "assets/" + cleanRunnerName + "RunnerRun1.png";
        const runnerRun2 = new Image();
        runnerRun2.src = "assets/" + cleanRunnerName + "RunnerRun2.png";
        const runnerDuck = new Image();
        runnerDuck.src = "assets/" + cleanRunnerName + "RunnerDuck.png";
        const runnerShot = new Image();
        runnerShot.src = "assets/" + cleanRunnerName + "RunnerShot.png";
        const runnerTumble = new Image();
        runnerTumble.src = "assets/" + cleanRunnerName + "RunnerTumble.png";

        // Preload chaser sprites
        const chaserWalk1 = new Image();
        chaserWalk1.src = "assets/" + cleanChaserName + "Walk1.png";
        const chaserWalk2 = new Image();
        chaserWalk2.src = "assets/" + cleanChaserName + "Walk2.png";
        const chaserShoot = new Image();
        chaserShoot.src = "assets/" + cleanChaserName + "Shoot.png";

        // Preload ground and obstacle sprites
        const groundImg = new Image();
        groundImg.src = "assets/" + cleanMapName + "Ground.png";
        const obstacleImg = new Image();
        obstacleImg.src = "assets/" + cleanMapName + "Object.png";
        
        // Background music - deferred creation using vanilla HTML5 Audio with zero external dependencies
        let bgMusic = null;
        let musicStarted = false;

        function startMusicOnInteraction() {
            if (musicStarted) return;
            musicStarted = true;
            try {
                if (!bgMusic) {
                    const songFile = "assets/" + cleanMapName + "Song.ogg";
                    bgMusic = new Audio(songFile);
                    bgMusic.loop = true;
                    bgMusic.volume = 0.5;
                }
                bgMusic.play().then(() => {
                    console.log("BGM playing successfully.");
                }).catch(err => {
                    console.warn("BGM play failed:", err.message);
                    musicStarted = false; // Allow retry
                });
            } catch(e) {
                console.warn("BGM error:", e);
                musicStarted = false;
            }
            window.removeEventListener('keydown', startMusicOnInteraction);
            window.removeEventListener('click', startMusicOnInteraction);
            window.removeEventListener('mousedown', startMusicOnInteraction);
            window.removeEventListener('touchstart', startMusicOnInteraction);
        }
        window.addEventListener('keydown', startMusicOnInteraction);
        window.addEventListener('click', startMusicOnInteraction);
        window.addEventListener('mousedown', startMusicOnInteraction);
        window.addEventListener('touchstart', startMusicOnInteraction);
        
        const canvas = document.getElementById('gameCanvas');
        const ctx = canvas.getContext('2d');
        const deck = document.getElementById('deck');
        
        // Setup coordinates
        const FLOOR_Y = 320;
        const CEILING_Y = 80;
        const PLAYER_HEIGHT = 88;
        const PLAYER_WIDTH = 56;

        // Abstract Class base
        class GameObject {
            #x;
            #y;
            #width;
            #height;

            constructor(x, y, width, height) {
                if (this.constructor === GameObject) {
                    throw new Error("Abstract Class 'GameObject' cannot be instantiated directly.");
                }
                this.#x = x;
                this.#y = y;
                this.#width = width;
                this.#height = height;
            }

            getX() { return this.#x; }
            setX(x) { this.#x = x; }

            getY() { return this.#y; }
            setY(y) { this.#y = y; }

            getWidth() { return this.#width; }
            setWidth(w) { this.#width = w; }

            getHeight() { return this.#height; }
            setHeight(h) { this.#height = h; }

            update(gameSpeed) {
                throw new Error("Method 'update(gameSpeed)' must be implemented by subclasses.");
            }

            draw(ctx) {
                throw new Error("Method 'draw(ctx)' must be implemented by subclasses.");
            }
        }

        // Particle Class inheriting from GameObject (Polymorphic particle trails)
        class Particle extends GameObject {
            #vx;
            #vy;
            #life;
            #color;

            constructor(x, y, vx, vy, color) {
                const size = Math.random() * 4 + 2;
                super(x, y, size, size);
                this.#vx = vx;
                this.#vy = vy;
                this.#life = 1.0;
                this.#color = color;
            }

            update(gameSpeed) {
                this.setX(this.getX() + this.#vx - gameSpeed * 0.15);
                this.setY(this.getY() + this.#vy);
                this.#life -= 0.03;
            }

            draw(ctx) {
                if (this.#life <= 0) return;
                ctx.save();
                ctx.globalAlpha = this.#life;
                ctx.fillStyle = this.#color;
                ctx.shadowBlur = 6;
                ctx.shadowColor = this.#color;
                ctx.fillRect(this.getX(), this.getY(), this.getWidth(), this.getHeight());
                ctx.restore();
            }

            isDead() {
                return this.#life <= 0;
            }
        }

        // Subclass Player extending GameObject
        class Player extends GameObject {
            #vy = 0;
            #gravityDir = 1; // 1 = down, -1 = up
            #onSurface = true;
            #isDucking = false;
            #primaryColor = "#4caf50"; // Green grass matching particles
            #legSwing = 0;
            #hitState = null; // "shot" or "tumble"
            #hitStateTimer = 0;

            constructor(x, y, skinType) {
                super(x, y, PLAYER_WIDTH, PLAYER_HEIGHT);
            }

            getGravityDir() { return this.#gravityDir; }
            getPrimaryColor() { return this.#primaryColor; }
            onSurface() { return this.#onSurface; }
            isDucking() { return this.#isDucking; }
            getHitState() { return this.#hitState; }
            setHitState(state, duration) {
                this.#hitState = state;
                this.#hitStateTimer = duration;
            }

            jump() {
                if (this.#onSurface && !this.#isDucking) {
                    this.#vy = -13.5; // upward impulse
                    this.#onSurface = false;
                    
                    // Spawn launch splash particles
                    for(let i = 0; i < 8; i++) {
                        particles.push(new Particle(
                            this.getX() + this.getWidth() / 2, 
                            FLOOR_Y,
                            (Math.random() - 0.5) * 4,
                            -(Math.random() * 2 + 1),
                            this.#primaryColor
                        ));
                    }
                }
            }

            duck(shouldDuck) {
                if (shouldDuck) {
                    if (!this.#isDucking) {
                        this.#isDucking = true;
                        this.setHeight(PLAYER_HEIGHT / 2);
                        if (this.#onSurface) {
                            this.setY(FLOOR_Y - this.getHeight());
                        }
                    }
                } else {
                    if (this.#isDucking) {
                        this.#isDucking = false;
                        this.setHeight(PLAYER_HEIGHT);
                        if (this.#onSurface) {
                            this.setY(FLOOR_Y - this.getHeight());
                        }
                    }
                }
            }

            update(gameSpeed) {
                // Decrement hit state timer
                if (this.#hitStateTimer > 0) {
                    this.#hitStateTimer--;
                    if (this.#hitStateTimer <= 0) {
                        this.#hitState = null;
                    }
                }

                // Read keyboard buffer for ducking
                const isDuckingInput = keys["ArrowDown"] || keys["KeyS"];
                this.duck(isDuckingInput && this.#onSurface);

                // Fall through holes physics
                if (this.getY() > FLOOR_Y - this.getHeight()) {
                    this.#vy += 0.65; // gravity in hole
                    this.setY(this.getY() + this.#vy);
                    
                    if (this.getY() > canvas.height) {
                        endGame();
                    }
                    return;
                }

                if (!this.#onSurface) {
                    // Gravity acceleration (constant down pull)
                    this.#vy += 0.65;
                    // Terminal velocity clamp
                    if (this.#vy > 12) this.#vy = 12;

                    let nextY = this.getY() + this.#vy;

                    // Collision with floor
                    if (nextY >= FLOOR_Y - this.getHeight()) {
                        // Check if landing on a hole
                        const overHole = checkOverHole(this.getX(), this.getWidth());
                        if (overHole) {
                            this.#onSurface = false;
                            this.setY(nextY);
                        } else {
                            nextY = FLOOR_Y - this.getHeight();
                            this.#vy = 0;
                            this.#onSurface = true;
                            this.setY(nextY);
                        }
                    } else {
                        this.setY(nextY);
                    }
                } else {
                    // On ground. Check if walked off a hole
                    const overHole = checkOverHole(this.getX(), this.getWidth());
                    if (overHole) {
                        this.#onSurface = false;
                        this.#vy = 0; // start falling down
                    } else {
                        this.setY(FLOOR_Y - this.getHeight());
                    }
                }

                // Incremental horizontal recovery back to safe zone (X = 320)
                const safeX = 320;
                if (this.getX() < safeX) {
                    this.setX(Math.min(safeX, this.getX() + 0.35));
                }

                // Leg running animation
                if (this.#onSurface) {
                    if (this.#isDucking) {
                        this.#legSwing = 0; // crouch/slide pose
                    } else {
                        this.#legSwing += 0.2 * (gameSpeed / 4);
                    }
                } else {
                    this.#legSwing = 0.5; // mid-air pose
                }

                // Emit running trail particles
                if (this.#onSurface && Math.random() < 0.3) {
                    particles.push(new Particle(
                        this.getX() + Math.random() * this.getWidth(),
                        FLOOR_Y,
                        -1 - Math.random() * 2,
                        -Math.random() * 1,
                        this.#primaryColor
                    ));
                }
            }

            draw(ctx) {
                ctx.save();
                const x = this.getX();
                // To keep the visual model at its full un-squeezed scale, we offset drawing Y if ducking
                const drawY = this.getY() - (PLAYER_HEIGHT - this.getHeight());
                const w = PLAYER_WIDTH;
                const h = PLAYER_HEIGHT;

                let activeSprite = runnerRun1;
                if (this.getY() > FLOOR_Y - this.getHeight() || this.#hitState === "tumble") {
                    activeSprite = runnerTumble;
                } else if (this.#hitState === "shot") {
                    activeSprite = runnerShot;
                } else if (this.#isDucking) {
                    activeSprite = runnerDuck;
                } else {
                    activeSprite = (Math.floor(this.#legSwing) % 2 === 0) ? runnerRun1 : runnerRun2;
                }

                ctx.drawImage(activeSprite, x, drawY, w, h);
                ctx.restore();
            }
        }

        // Subclass Chaser extending GameObject
        class Chaser extends GameObject {
            #primaryColor = "#ff0055"; // Red laser/projectile matching
            #walkFrame = 0;
            #shootCooldown;
            #shootAnimTimer = 0;
            #trackingSpeed = 0.08;
            #yOffset = 0;

            constructor(x, y, skinType, trackingSpeed, yOffset) {
                super(x, y, 96, 120);
                this.#trackingSpeed = trackingSpeed !== undefined ? trackingSpeed : 0.08;
                this.#yOffset = yOffset !== undefined ? yOffset : 0;
                this.#shootCooldown = 800 + Math.random() * 800; // scattered shooting starts (less often)
            }

            update(gameSpeed) {
                // Pursuit AI: Track Player Y coordinate smoothly with a slight delay and horizontal-based vertical offsets
                const targetY = player.getY() - (this.getHeight() - player.getHeight()) / 2 + this.#yOffset;
                const currentY = this.getY();
                
                // Linear interpolation for Y axis tracking
                this.setY(currentY + (targetY - currentY) * this.#trackingSpeed);

                this.#walkFrame++;

                // Shoot projectile logic
                if (this.#shootCooldown > 0) {
                    this.#shootCooldown--;
                } else if (!isGameOver) {
                    // Shoot!
                    projectiles.push(new Projectile(this.getX() + this.getWidth(), FLOOR_Y - 65));
                    this.#shootCooldown = 1000 + Math.random() * 1000; // reset cooldown (scattered frequency, less often)
                    this.#shootAnimTimer = 30; // show shoot sprite for 30 frames
                }

                if (this.#shootAnimTimer > 0) {
                    this.#shootAnimTimer--;
                }


            }

            draw(ctx) {
                ctx.save();
                const x = this.getX();
                const y = this.getY();
                const w = this.getWidth();
                const h = this.getHeight();

                let activeSprite = chaserWalk1;
                if (this.#shootAnimTimer > 0) {
                    activeSprite = chaserShoot;
                } else {
                    activeSprite = (Math.floor(this.#walkFrame / 8) % 2 === 0) ? chaserWalk1 : chaserWalk2;
                }

                ctx.drawImage(activeSprite, x, y, w, h);
                ctx.restore();
            }
        }

        // Subclass Obstacle extending GameObject
        class Obstacle extends GameObject {
            #theme;
            #posType; // "floor" or "ceiling"
            #hasCollided = false;

            constructor(x, y, width, height, posType, theme) {
                super(x, y, width, height);
                this.#posType = posType;
                this.#theme = theme;
            }

            hasCollided() { return this.#hasCollided; }
            setCollided(val) { this.#hasCollided = val; }
            getPosType() { return this.#posType; }

            update(gameSpeed) {
                // Scroll off-screen right-to-left
                this.setX(this.getX() - gameSpeed);
            }

            draw(ctx) {
                ctx.save();
                const x = this.getX();
                const y = this.getY();
                const w = this.getWidth();
                const h = this.getHeight();

                ctx.drawImage(obstacleImg, x, y, w, h);
                ctx.restore();
            }
        }

        // Hole Class for environmental hazard gaps
        class Hole {
            #x;
            #width;

            constructor(x, width) {
                this.#x = x;
                this.#width = width;
            }

            getX() { return this.#x; }
            setX(x) { this.#x = x; }
            getWidth() { return this.#width; }

            update(gameSpeed) {
                this.#x -= gameSpeed;
            }

            isOffScreen() {
                return this.#x + this.#width < 0;
            }
        }

        // Projectile Class representing chaser's projectile fire
        class Projectile extends GameObject {
            constructor(x, y) {
                super(x, y, 20, 6); // size of bullet
            }

            update(gameSpeed) {
                // Travels at a slower, reactable speed to the right
                this.setX(this.getX() + gameSpeed * 0.35 + 0.5);
            }

            draw(ctx) {
                ctx.save();
                ctx.shadowBlur = 10;
                ctx.shadowColor = "#ff1100"; // Red glow
                ctx.fillStyle = "#ff5533"; // Orange-red bullet
                ctx.fillRect(this.getX(), this.getY(), this.getWidth(), this.getHeight());
                ctx.restore();
            }
        }

        // Initialize Instances
        const player = new Player(320, FLOOR_Y - PLAYER_HEIGHT, RUNNER_SKIN);
        const chasers = [
            new Chaser(10, FLOOR_Y - 120, CHASER_SKIN, 0.06, -10),  // Back chaser
            new Chaser(60, FLOOR_Y - 120, CHASER_SKIN, 0.08, 0),    // Middle chaser
            new Chaser(110, FLOOR_Y - 120, CHASER_SKIN, 0.10, 10)    // Front chaser
        ];

        // Active Game Collections
        const gameObjects = [];
        gameObjects.push(player);
        chasers.forEach(c => gameObjects.push(c));

        const obstacles = [];
        const holes = [];
        const particles = [];
        const projectiles = [];

        // Game Settings
        let gameSpeed = 4.5;
        let score = 0;
        let isGameOver = false;
        let frameCount = 0;
        let obstacleSpawnTimer = 0;
        let minSpawnInterval = 100; // in frames

        // Visual Hit Effect Variables
        let hitFlashFrames = 0;

        // Gravity swap paths bounds
        const floorBarrierY = FLOOR_Y;
        const ceilingBarrierY = CEILING_Y;

        // Background scroll positions
        let bgScrollX = 0;
        let groundScrollX = 0;

        // Handles Keyboard Event with State Registry
        const keys = {};
        window.addEventListener('keydown', (e) => {
            if (["Space", "ArrowUp", "ArrowDown", "KeyS", "KeyW"].includes(e.code) || e.key === " ") {
                e.preventDefault(); // prevent scrolling/space actions
            }
            const code = e.code || (e.key === " " ? "Space" : "");
            if (code) {
                // Trigger jump on first key press edge
                if ((code === "Space" || code === "ArrowUp" || code === "KeyW") && !keys[code]) {
                    if (!isGameOver) {
                        player.jump();
                    }
                }
                keys[code] = true;
            }
        });
        window.addEventListener('keyup', (e) => {
            const code = e.code || (e.key === " " ? "Space" : "");
            if (code) {
                keys[code] = false;
            }
        });

        // Trigger Screen Shake and Red Flash
        function triggerHitEffect() {
            hitFlashFrames = 10;
            deck.classList.add('shake');
            setTimeout(() => {
                deck.classList.remove('shake');
            }, 200);
        }

        // Render Background Theme
        function drawBackground() {
            // Loop mapImg1 and mapImg2 side-by-side (each stretched to universal 800x400)
            let scrollVal = Math.abs(bgScrollX) % 1600;
            
            // Draw mapImg1
            let x1 = -scrollVal;
            if (x1 < -800) x1 += 1600;
            ctx.drawImage(mapImg1, x1, 0, 800, 400);

            // Draw mapImg2
            let x2 = -scrollVal + 800;
            if (x2 < -800) x2 += 1600;
            ctx.drawImage(mapImg2, x2, 0, 800, 400);

            // Draw floor segments around active holes
            ctx.save();
            ctx.shadowBlur = 0; // Disable cyber glow on natural grass ground
            
            let usePattern = groundImg.complete && groundImg.naturalWidth !== 0;

            let lastX = 0;
            const sortedHoles = [...holes].sort((a, b) => a.getX() - b.getX());
            sortedHoles.forEach(hole => {
                const hX = hole.getX();
                const hW = hole.getWidth();
                if (hX > lastX) {
                    ctx.save();
                    // Clip to current floor segment bounds
                    ctx.beginPath();
                    ctx.rect(lastX, FLOOR_Y, hX - lastX, canvas.height - FLOOR_Y);
                    ctx.clip();

                    if (usePattern) {
                        const imgW = groundImg.naturalWidth;
                        const imgH = canvas.height - FLOOR_Y;
                        let scrollVal = Math.abs(groundScrollX) % imgW;
                        
                        let x1 = -scrollVal;
                        ctx.drawImage(groundImg, x1, FLOOR_Y, imgW, imgH);
                        
                        let x2 = -scrollVal + imgW;
                        ctx.drawImage(groundImg, x2, FLOOR_Y, imgW, imgH);
                    } else {
                        const fallbackGrad = ctx.createLinearGradient(0, FLOOR_Y, 0, canvas.height);
                        fallbackGrad.addColorStop(0, "#4caf50");
                        fallbackGrad.addColorStop(1, "#1b5e20");
                        ctx.fillStyle = fallbackGrad;
                        ctx.fillRect(lastX, FLOOR_Y, hX - lastX, canvas.height - FLOOR_Y);
                    }
                    ctx.restore();
                    
                    // Draw grass top stroke line
                    ctx.save();
                    ctx.strokeStyle = "#4caf50";
                    ctx.lineWidth = 3;
                    ctx.beginPath();
                    ctx.moveTo(lastX, FLOOR_Y);
                    ctx.lineTo(hX, FLOOR_Y);
                    ctx.stroke();
                    ctx.restore();
                }
                lastX = hX + hW;
            });
            if (lastX < canvas.width) {
                ctx.save();
                ctx.beginPath();
                ctx.rect(lastX, FLOOR_Y, canvas.width - lastX, canvas.height - FLOOR_Y);
                ctx.clip();

                if (usePattern) {
                    const imgW = groundImg.naturalWidth;
                    const imgH = canvas.height - FLOOR_Y;
                    let scrollVal = Math.abs(groundScrollX) % imgW;
                    
                    let x1 = -scrollVal;
                    ctx.drawImage(groundImg, x1, FLOOR_Y, imgW, imgH);
                    
                    let x2 = -scrollVal + imgW;
                    ctx.drawImage(groundImg, x2, FLOOR_Y, imgW, imgH);
                } else {
                    const fallbackGrad = ctx.createLinearGradient(0, FLOOR_Y, 0, canvas.height);
                    fallbackGrad.addColorStop(0, "#4caf50");
                    fallbackGrad.addColorStop(1, "#1b5e20");
                    ctx.fillStyle = fallbackGrad;
                    ctx.fillRect(lastX, FLOOR_Y, canvas.width - lastX, canvas.height - FLOOR_Y);
                }
                ctx.restore();
                
                // Draw grass top stroke line
                ctx.save();
                ctx.strokeStyle = "#4caf50";
                ctx.lineWidth = 3;
                ctx.beginPath();
                ctx.moveTo(lastX, FLOOR_Y);
                ctx.lineTo(canvas.width, FLOOR_Y);
                ctx.stroke();
                ctx.restore();
            }

            // Draw dark pit voids inside holes
            holes.forEach(hole => {
                ctx.save();
                // Dark pit gradient
                const pitGrad = ctx.createLinearGradient(0, FLOOR_Y, 0, canvas.height);
                pitGrad.addColorStop(0, "rgba(0, 0, 0, 0.95)");
                pitGrad.addColorStop(1, "rgba(10, 10, 10, 1)");
                ctx.fillStyle = pitGrad;
                ctx.fillRect(hole.getX(), FLOOR_Y, hole.getWidth(), canvas.height - FLOOR_Y);
                ctx.restore();
            });

            // Draw glowing moss-green vertical depth drops inside holes
            holes.forEach(hole => {
                ctx.save();
                ctx.shadowBlur = 8;
                ctx.shadowColor = "#1b5e20"; // Dark moss green glow
                ctx.strokeStyle = "rgba(46, 125, 50, 0.6)";
                ctx.lineWidth = 3;
                
                const hX = hole.getX();
                const hW = hole.getWidth();
                ctx.beginPath();
                ctx.moveTo(hX, FLOOR_Y);
                ctx.lineTo(hX, FLOOR_Y + 40);
                ctx.moveTo(hX + hW, FLOOR_Y);
                ctx.lineTo(hX + hW, FLOOR_Y + 40);
                ctx.stroke();
                ctx.restore();
            });

            ctx.restore();

            // Draw moving horizontal lane guides (floor only, no ceiling guides)
            bgScrollX = (bgScrollX - gameSpeed * 0.5) % 1600;
            ctx.save();
            ctx.strokeStyle = "rgba(255, 255, 255, 0.06)";
            ctx.lineWidth = 1;
            for (let x = bgScrollX % 40; x < canvas.width; x += 40) {
                // Floor guides (only draw if not in a hole)
                let inHole = false;
                for (let i = 0; i < holes.length; i++) {
                    const hole = holes[i];
                    if (x > hole.getX() && x < hole.getX() + hole.getWidth()) {
                        inHole = true;
                        break;
                    }
                }
                if (!inHole) {
                    ctx.beginPath();
                    ctx.moveTo(x, FLOOR_Y);
                    ctx.lineTo(x, canvas.height);
                    ctx.stroke();
                }
            }
            ctx.restore();

            // Ambient background particles (golden floating embers)
            ctx.fillStyle = "rgba(255, 215, 0, 0.15)";
            for (let i = 0; i < 6; i++) {
                const dx = (canvas.width - ((frameCount * 0.5 + i * 150) % (canvas.width + 20)));
                const dy = CEILING_Y + 20 + Math.sin(frameCount * 0.02 + i) * 30 + (i * 30);
                ctx.beginPath();
                ctx.arc(dx, dy, 1.5, 0, Math.PI * 2);
                ctx.fill();
            }
        }

        // Check if player center is over a hole
        function checkOverHole(px, pWidth) {
            const pCenter = px + pWidth / 2;
            for (let i = 0; i < holes.length; i++) {
                const hole = holes[i];
                if (pCenter > hole.getX() && pCenter < hole.getX() + hole.getWidth()) {
                    return true;
                }
            }
            return false;
        }

        // Checks Bounding Box Collision
        function checkCollision(objA, objB) {
            return objA.getX() < objB.getX() + objB.getWidth() &&
                   objA.getX() + objA.getWidth() > objB.getX() &&
                   objA.getY() < objB.getY() + objB.getHeight() &&
                   objA.getY() + objA.getHeight() > objB.getY();
        }

        // Main game Loop
        function gameLoop() {
            if (isGameOver) return;

            frameCount++;
            obstacleSpawnTimer++;

            // 1. Calculate stats
            score = Math.floor(frameCount / 6);
            document.getElementById('hudScore').innerText = score + "m";

            // Baseline Speed Scaling over time
            gameSpeed = 4.5 + (frameCount * 0.0006);
            document.getElementById('speedIndicator').innerText = "SPEED: " + (gameSpeed / 4.5).toFixed(1) + "x";

            // Scroll ground platform texture in lockstep with obstacle speed
            groundScrollX -= gameSpeed;

            // Threat level gauge calculated by distance between Player and closest Chaser
            let maxChaserRight = 0;
            chasers.forEach(c => {
                const rightEdge = c.getX() + c.getWidth();
                if (rightEdge > maxChaserRight) {
                    maxChaserRight = rightEdge;
                }
            });
            const gap = player.getX() - maxChaserRight;
            // Map gap to threat level percentage (Max gap = 320 - 206 = 114px)
            let threatPct = Math.floor((1 - (gap / 114)) * 100);
            threatPct = Math.max(0, Math.min(100, threatPct));

            const threatFill = document.getElementById('threatFill');
            const threatPercent = document.getElementById('threatPercent');
            
            threatFill.style.width = threatPct + "%";
            threatPercent.innerText = threatPct + "%";

            // Update Threat Gauge colors dynamically
            if (threatPct < 35) {
                threatFill.style.backgroundColor = "#6366f1"; // Indigo
            } else if (threatPct < 75) {
                threatFill.style.backgroundColor = "#a855f7"; // Purple
            } else {
                threatFill.style.backgroundColor = "#ec4899"; // Pink
            }

            // 2. Clear canvas
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            // 3. Render visual backgrounds
            drawBackground();

            // 4. Random obstacle or hole Spawning
            if (obstacleSpawnTimer > minSpawnInterval) {
                const spawnX = 850;
                
                const spawnRoll = Math.random();
                if (spawnRoll < 0.40) {
                    // Spawn a pit/hole (40% chance)
                    const holeWidth = 60 + Math.random() * 25; // 60-85px
                    holes.push(new Hole(spawnX, holeWidth));
                } else if (spawnRoll < 0.70) {
                    // Spawn a floor hurdle (30% chance)
                    const posType = "floor";
                    const obsWidth = 48 + Math.random() * 24;
                    const obsHeight = 70 + Math.random() * 20;
                    const obsY = FLOOR_Y - obsHeight;

                    const obs = new Obstacle(spawnX, obsY, obsWidth, obsHeight, posType, MAP_THEME);
                    obstacles.push(obs);
                    gameObjects.push(obs);
                } else {
                    // Spawn nothing (30% chance) - gives breathing room
                }
                
                obstacleSpawnTimer = 0;
                // Randomize spawn window slightly (increased spacing)
                minSpawnInterval = 130 + Math.random() * 70 - (gameSpeed * 3);
                if (minSpawnInterval < 70) minSpawnInterval = 70; // safety ceiling
            }

            // 5. Polymorphically Update and Draw all GameObjects
            // Use reverse loop for index modification safeties
            for (let i = gameObjects.length - 1; i >= 0; i--) {
                const obj = gameObjects[i];
                obj.update(gameSpeed);
                obj.draw(ctx);
            }

            // 5.5. Update active holes
            for (let i = holes.length - 1; i >= 0; i--) {
                const hole = holes[i];
                hole.update(gameSpeed);
                if (hole.isOffScreen()) {
                    holes.splice(i, 1);
                }
            }

            // 6. Update and Draw active particles collection
            for (let i = particles.length - 1; i >= 0; i--) {
                const p = particles[i];
                p.update(gameSpeed);
                p.draw(ctx);
                if (p.isDead()) {
                    particles.splice(i, 1);
                }
            }

            // 6.5. Update and Draw active projectiles
            for (let i = projectiles.length - 1; i >= 0; i--) {
                const proj = projectiles[i];
                proj.update(gameSpeed);
                proj.draw(ctx);
                
                // Check collision with player
                if (checkCollision(player, proj)) {
                    projectiles.splice(i, 1);
                    triggerHitEffect();
                    
                    // Knock back penalty using the right-most (closest) chaser's front edge
                    let currentClosestChaserRight = 0;
                    chasers.forEach(c => {
                        const rightEdge = c.getX() + c.getWidth();
                        if (rightEdge > currentClosestChaserRight) {
                            currentClosestChaserRight = rightEdge;
                        }
                    });
                    const penaltyX = player.getX() - 55;
                    player.setX(Math.max(currentClosestChaserRight + 8, penaltyX));
                    
                    // Set player visual hit state
                    player.setHitState("shot", 25);
                    
                    // Spawn red burst particles
                    for(let k = 0; k < 8; k++) {
                        particles.push(new Particle(
                            player.getX() + player.getWidth() / 2,
                            player.getY() + player.getHeight() / 2,
                            (Math.random() - 0.5) * 6 - 2,
                            (Math.random() - 0.5) * 6,
                            "#ff1100"
                        ));
                    }
                    continue;
                }
                
                // Remove if off screen
                if (proj.getX() > canvas.width) {
                    projectiles.splice(i, 1);
                }
            }

            // 7. Process collision checks with obstacles
            obstacles.forEach(obs => {
                if (!obs.hasCollided() && checkCollision(player, obs)) {
                    obs.setCollided(true);
                    triggerHitEffect();

                    // Apply distance penalty: drops player back towards chaser
                    // Reduce player's X coordinate (moves left)
                    let currentClosestChaserRight = 0;
                    chasers.forEach(c => {
                        const rightEdge = c.getX() + c.getWidth();
                        if (rightEdge > currentClosestChaserRight) {
                            currentClosestChaserRight = rightEdge;
                        }
                    });
                    const penaltyX = player.getX() - 65;
                    player.setX(Math.max(currentClosestChaserRight + 8, penaltyX));

                    // Set player visual hit state
                    player.setHitState("tumble", 25);

                    // Burst particle splash effects
                    const pColor = player.getPrimaryColor();
                    for(let k = 0; k < 15; k++) {
                        particles.push(new Particle(
                            player.getX() + player.getWidth() / 2,
                            player.getY() + player.getHeight() / 2,
                            (Math.random() - 0.5) * 8 - 2,
                            (Math.random() - 0.5) * 8,
                            pColor
                        ));
                    }
                }
            });

            // 8. Clean up off-screen obstacles to save memory
            for (let i = obstacles.length - 1; i >= 0; i--) {
                const obs = obstacles[i];
                if (obs.getX() + obs.getWidth() < 0) {
                    obstacles.splice(i, 1);
                    const idx = gameObjects.indexOf(obs);
                    if (idx > -1) {
                        gameObjects.splice(idx, 1);
                    }
                }
            }

            // 9. Check Captured state conditions (Game Over)
            // If any chaser touches the player
            for (let i = 0; i < chasers.length; i++) {
                if (chasers[i].getX() + chasers[i].getWidth() >= player.getX()) {
                    endGame();
                    break;
                }
            }

            // Render collision hit flash overlay
            if (hitFlashFrames > 0) {
                ctx.fillStyle = `rgba(255, 0, 0, ${hitFlashFrames * 0.04})`;
                ctx.fillRect(0, 0, canvas.width, canvas.height);
                hitFlashFrames--;
            }

            requestAnimationFrame(gameLoop);
        }

        // Trigger Game Over State
        function endGame() {
            if (bgMusic) bgMusic.pause();
            isGameOver = true;
            document.getElementById('finalScoreText').innerText = score + "m";
            document.getElementById('formScore').value = score;
            document.getElementById('gameOverOverlay').style.display = "flex";

            // Spawn giant particle burst on player capture
            const pColor = player.getPrimaryColor();
            for(let i = 0; i < 40; i++) {
                particles.push(new Particle(
                    player.getX() + player.getWidth() / 2,
                    player.getY() + player.getHeight() / 2,
                    (Math.random() - 0.5) * 12,
                    (Math.random() - 0.5) * 12,
                    pColor
                ));
            }

            // Perform a final render of particles so burst is visible
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            drawBackground();
            // Draw characters final static pose
            player.draw(ctx);
            chasers.forEach(c => c.draw(ctx));
            // Draw particles
            particles.forEach(p => {
                p.update(0);
                p.draw(ctx);
            });
        }

        // Kickoff
        requestAnimationFrame(gameLoop);
    </script>
</body>
</html>
