<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Corian: Las sombras de Atl - Panel de Control & Base de Datos</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-lavender: #9aa0f8;
            --purple-primary: #7065f0;
            --purple-hover: #5e52e6;
            --purple-light: #ecebff;
            --purple-border: rgba(112, 101, 240, 0.25);
            --card-bg: #ffffff;
            --pill-bg: #f4f5f9;
            --pill-hover: #e9ebf5;
            --text-dark: #1e1b4b;
            --text-muted: #8e8ba7;
            --text-body: #474464;
            --border-subtle: #e2e8f0;
            --success: #10b981;
            --danger: #ef4444;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        body {
            background-color: var(--bg-lavender);
            background: linear-gradient(135deg, #a2a7fb 0%, #9196f7 50%, #9aa0f8 100%);
            min-height: 100vh;
            color: var(--text-dark);
            display: flex;
            flex-direction: column;
            padding: 24px;
        }

        /* Encabezado Principal */
        header {
            max-width: 1280px;
            width: 100%;
            margin: 0 auto 20px auto;
            background: var(--card-bg);
            border-radius: 24px;
            padding: 16px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 10px 30px rgba(45, 35, 110, 0.12);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .brand-icon {
            width: 42px;
            height: 42px;
            background: var(--purple-light);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--purple-primary);
            font-size: 1.3rem;
            font-weight: 800;
        }

        .brand-title {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--text-dark);
            letter-spacing: -0.3px;
        }

        .brand-sub {
            font-size: 0.78rem;
            color: var(--text-muted);
            font-weight: 500;
        }

        .status-badges {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .badge-pill {
            background: var(--pill-bg);
            padding: 6px 14px;
            border-radius: 9999px;
            font-size: 0.78rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-dark);
        }

        .badge-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--success);
            box-shadow: 0 0 8px rgba(16, 185, 129, 0.5);
        }

        /* Estructura del Panel de Dos Columnas (Como antes) */
        main {
            max-width: 1280px;
            width: 100%;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            flex: 1;
        }

        @media (max-width: 960px) {
            main {
                grid-template-columns: 1fr;
            }
        }

        /* Tarjetas de Panel */
        .card {
            background: var(--card-bg);
            border-radius: 28px;
            padding: 26px;
            box-shadow: 0 15px 35px rgba(45, 35, 110, 0.12);
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 14px;
            border-bottom: 1px solid var(--pill-bg);
        }

        .card-title {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-tag {
            background: var(--purple-light);
            color: var(--purple-primary);
            font-size: 0.75rem;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 9999px;
        }

        /* Formulario y Píldoras de Entrada */
        .input-group {
            display: flex;
            gap: 10px;
        }

        .input-pill {
            background: var(--pill-bg);
            border: 1.5px solid transparent;
            border-radius: 9999px;
            padding: 12px 20px;
            font-size: 0.9rem;
            color: var(--text-dark);
            outline: none;
            flex: 1;
            transition: all 0.2s;
        }

        .input-pill:focus {
            border-color: var(--purple-primary);
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(112, 101, 240, 0.12);
        }

        .btn-pill {
            background: #ffffff;
            border: 2px solid var(--purple-primary);
            color: var(--purple-primary);
            border-radius: 9999px;
            padding: 11px 22px;
            font-size: 0.9rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .btn-pill:hover {
            background: var(--purple-primary);
            color: #ffffff;
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(112, 101, 240, 0.25);
        }

        .btn-pill-primary {
            background: var(--purple-primary);
            color: #ffffff;
            border: 2px solid var(--purple-primary);
        }

        .btn-pill-primary:hover {
            background: var(--purple-hover);
            border-color: var(--purple-hover);
        }

        /* Grid de Métricas / HUD */
        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
        }

        .metric-pill {
            background: var(--pill-bg);
            border-radius: 20px;
            padding: 14px;
            text-align: center;
            transition: transform 0.2s;
        }

        .metric-pill:hover {
            transform: translateY(-2px);
        }

        .metric-label {
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .metric-value {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--purple-primary);
            margin-top: 4px;
        }

        /* Botones de Acción Rápida (Simulación) */
        .actions-group {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
        }

        .action-button {
            background: var(--pill-bg);
            border: 1px solid transparent;
            color: var(--text-dark);
            border-radius: 16px;
            padding: 12px 14px;
            font-size: 0.82rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            text-align: left;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .action-button:hover {
            background: var(--purple-light);
            border-color: var(--purple-border);
            color: var(--purple-primary);
            transform: translateY(-1px);
        }

        /* Terminal de Logs en Estilo Píldora Suave */
        .log-box {
            background: var(--pill-bg);
            border-radius: 18px;
            padding: 14px 18px;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.75rem;
            color: var(--text-body);
            max-height: 140px;
            overflow-y: auto;
            line-height: 1.6;
        }

        .log-entry {
            display: flex;
            gap: 8px;
            margin-bottom: 4px;
        }

        .log-time {
            color: var(--purple-primary);
            font-weight: 700;
        }

        /* Panel Derecho: Lista de Sesiones Guardadas en PostgreSQL */
        .sessions-list-container {
            display: flex;
            flex-direction: column;
            gap: 10px;
            max-height: 220px;
            overflow-y: auto;
            padding-right: 4px;
        }

        .session-row {
            background: var(--pill-bg);
            border-radius: 16px;
            padding: 12px 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            cursor: pointer;
            transition: all 0.2s;
            border: 1.5px solid transparent;
        }

        .session-row:hover {
            background: var(--pill-hover);
        }

        .session-row.active {
            background: var(--purple-light);
            border-color: var(--purple-primary);
        }

        .session-info {
            display: flex;
            flex-direction: column;
        }

        .session-name {
            font-size: 0.9rem;
            font-weight: 800;
            color: var(--text-dark);
        }

        .session-sub {
            font-size: 0.72rem;
            color: var(--text-muted);
            margin-top: 2px;
        }

        .btn-delete-row {
            background: transparent;
            border: none;
            color: #cbd5e1;
            cursor: pointer;
            padding: 6px;
            border-radius: 8px;
            transition: all 0.2s;
            display: flex;
            align-items: center;
        }

        .btn-delete-row:hover {
            color: var(--danger);
            background: rgba(239, 68, 68, 0.1);
        }

        /* Inspector de JSONB */
        .json-preview {
            background: var(--pill-bg);
            border-radius: 18px;
            padding: 16px;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.74rem;
            color: #3730a3;
            max-height: 230px;
            overflow-y: auto;
            line-height: 1.5;
            border: 1px solid var(--border-subtle);
        }

        /* Notificación Toast */
        .toast {
            position: fixed;
            bottom: 24px;
            right: 24px;
            background: var(--card-bg);
            border: 2px solid var(--purple-primary);
            color: var(--text-dark);
            padding: 12px 20px;
            border-radius: 9999px;
            font-size: 0.85rem;
            font-weight: 700;
            box-shadow: 0 10px 25px rgba(45, 35, 110, 0.2);
            opacity: 0;
            transform: translateY(10px);
            transition: all 0.25s ease;
            pointer-events: none;
            z-index: 100;
        }

        .toast.visible {
            opacity: 1;
            transform: translateY(0);
        }
    </style>
</head>
<body>

    <!-- Encabezado Limpio con los colores y minimalismo -->
    <header>
        <div class="brand">
            <div class="brand-icon">⚔️</div>
            <div>
                <h1 class="brand-title">Corian: Las sombras de Atl</h1>
                <p class="brand-sub">Panel de Base de Datos & Telemetría API</p>
            </div>
        </div>

        <div class="status-badges">
            <div class="badge-pill">
                <span class="badge-dot"></span>
                <span>Nginx :80 (Proxy)</span>
            </div>
            <div class="badge-pill">
                <span class="badge-dot"></span>
                <span>Laravel 10 / PHP 8.2</span>
            </div>
            <div class="badge-pill">
                <span class="badge-dot"></span>
                <span>PostgreSQL 15 (JSONB)</span>
            </div>
        </div>
    </header>

    <!-- Estructura de Dos Columnas (Panel Principal) -->
    <main>

        <!-- Columna Izquierda: Gestión & Simulación -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">⚡ Gestión de Jugador & Sesión</h2>
                <span class="card-tag" id="session-tag">Sin sesión</span>
            </div>

            <!-- Registro / Crear Sesión -->
            <div>
                <label style="display:block; font-size:0.8rem; font-weight:600; color:var(--text-muted); margin-bottom:8px;">
                    Registrar o Iniciar Sesión (crea UUID en PostgreSQL):
                </label>
                <div class="input-group">
                    <input type="text" id="input-alias" class="input-pill" placeholder="Alias del jugador..." value="Corian_Explorador">
                    <button class="btn-pill" onclick="iniciarSesion()">
                        Crear Sesión
                    </button>
                </div>
            </div>

            <!-- Métricas / HUD -->
            <div class="metrics-grid">
                <div class="metric-pill">
                    <div class="metric-label">Nivel</div>
                    <div class="metric-value" id="val-nivel">1</div>
                </div>
                <div class="metric-pill">
                    <div class="metric-label">Puntos</div>
                    <div class="metric-value" id="val-puntos">0</div>
                </div>
                <div class="metric-pill">
                    <div class="metric-label">Tiempo</div>
                    <div class="metric-value" id="val-tiempo">0s</div>
                </div>
            </div>

            <!-- Acciones de Simulación -->
            <div>
                <label style="display:block; font-size:0.8rem; font-weight:600; color:var(--text-muted); margin-bottom:8px;">
                    Simulación de Progreso (actualiza en memoria):
                </label>
                <div class="actions-group">
                    <button class="action-button" onclick="simularMision()">
                        <span>🗡️ Explorar Ruinas</span>
                        <span style="color:var(--purple-primary);">+150 pts</span>
                    </button>
                    <button class="action-button" onclick="simularSubidaNivel()">
                        <span>⭐ Subir Nivel</span>
                        <span style="color:var(--purple-primary);">+1 Nivel</span>
                    </button>
                    <button class="action-button" onclick="simularDecisionEtica('comunidad')">
                        <span>🌱 Decisión Altruista</span>
                        <span style="color:var(--success);">+Empatía</span>
                    </button>
                    <button class="action-button" onclick="simularDecisionEtica('poder')">
                        <span>⚡ Decisión Individual</span>
                        <span style="color:var(--purple-primary);">+Ataque</span>
                    </button>
                </div>
            </div>

            <!-- Botones de Persistencia en Base de Datos -->
            <div style="display:flex; gap:12px;">
                <button class="btn-pill btn-pill-primary" style="flex:1;" onclick="guardarEnPostgreSQL()">
                    💾 Guardar en PostgreSQL (PUT)
                </button>
                <button class="btn-pill" style="flex:1;" onclick="recargarDesdePostgreSQL()">
                    🔄 Recargar de BD (GET)
                </button>
            </div>

            <!-- Terminal de Eventos -->
            <div>
                <label style="display:block; font-size:0.75rem; font-weight:600; color:var(--text-muted); margin-bottom:6px;">
                    Registro de Eventos y Red (HTTP API):
                </label>
                <div class="log-box" id="terminal-logs">
                    <div class="log-entry"><span class="log-time">[OK]</span> Servidor Nginx conectado en puerto 80.</div>
                </div>
            </div>
        </div>

        <!-- Columna Derecha: Inspector de Base de Datos y JSONB -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">🗄️ Registros en PostgreSQL</h2>
                <span class="card-tag" id="total-count-tag">0 registros</span>
            </div>

            <!-- Buscador estilo píldora -->
            <div>
                <input type="text" id="search-box" class="input-pill" style="width:100%;" placeholder="🔍 Buscar por nombre o UUID..." oninput="filtrarRegistros()">
            </div>

            <!-- Lista de Jugadores / Sesiones en la Base de Datos -->
            <div>
                <label style="display:block; font-size:0.8rem; font-weight:600; color:var(--text-muted); margin-bottom:8px;">
                    Sesiones registradas en tabla <strong>jugadores_sesion</strong>:
                </label>
                <div class="sessions-list-container" id="sessions-container">
                    <div style="text-align:center; padding:20px; font-size:0.8rem; color:var(--text-muted);">
                        Cargando datos de la base de datos...
                    </div>
                </div>
            </div>

            <!-- Inspector de JSONB (tabla progreso_juego) -->
            <div>
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                    <label style="font-size:0.8rem; font-weight:700; color:var(--text-dark);">
                        Campo <strong>estado_json</strong> (JSONB):
                    </label>
                    <span style="font-size:0.72rem; color:var(--purple-primary); font-weight:700;">
                        Índice GIN Activo
                    </span>
                </div>
                <pre class="json-preview" id="jsonb-viewer">// Selecciona una sesión para ver su JSONB...</pre>
            </div>
        </div>

    </main>

    <!-- Toast flotante -->
    <div class="toast" id="toast-notification">Operación exitosa</div>

    <script>
        let currentSession = {
            id: null,
            alias: '',
            nivel: 1,
            puntos: 0,
            tiempo: 0,
            estadoJson: {}
        };

        let dbSessionsList = [];

        function addLog(msg) {
            const box = document.getElementById('terminal-logs');
            const now = new Date().toLocaleTimeString();
            const div = document.createElement('div');
            div.className = 'log-entry';
            div.innerHTML = `<span class="log-time">[${now}]</span> <span>${escapeHtml(msg)}</span>`;
            box.prepend(div);
        }

        function showToast(msg) {
            const t = document.getElementById('toast-notification');
            t.innerText = msg;
            t.classList.add('visible');
            setTimeout(() => t.classList.remove('visible'), 2800);
        }

        function updateUI() {
            document.getElementById('val-nivel').innerText = currentSession.nivel;
            document.getElementById('val-puntos').innerText = currentSession.puntos;
            document.getElementById('val-tiempo').innerText = currentSession.tiempo + 's';
            document.getElementById('jsonb-viewer').innerText = JSON.stringify(currentSession.estadoJson, null, 2);

            if (currentSession.id) {
                document.getElementById('session-tag').innerText = `UUID: ${currentSession.id.substring(0, 8)}...`;
            } else {
                document.getElementById('session-tag').innerText = 'Sin sesión';
            }
        }

        // Cargar todos los registros desde PostgreSQL
        async function fetchAllRecords() {
            try {
                const res = await fetch('/api/juego/todos');
                const data = await res.json();
                dbSessionsList = data.jugadores || [];
                document.getElementById('total-count-tag').innerText = `${dbSessionsList.length} registros`;
                renderSessionsList(dbSessionsList);

                // Si no hay sesión seleccionada y hay registros, selecciona el primero
                if (!currentSession.id && dbSessionsList.length > 0) {
                    selectSession(dbSessionsList[0].id);
                }
            } catch (err) {
                addLog('Error consultando base de datos: ' + err.message);
            }
        }

        function renderSessionsList(list) {
            const container = document.getElementById('sessions-container');
            container.innerHTML = '';

            if (list.length === 0) {
                container.innerHTML = '<div style="text-align:center; padding:20px; font-size:0.8rem; color:var(--text-muted);">No hay sesiones en la base de datos. Crea una a la izquierda.</div>';
                return;
            }

            list.forEach(s => {
                const row = document.createElement('div');
                row.className = 'session-row' + (currentSession.id === s.id ? ' active' : '');
                row.onclick = () => selectSession(s.id);

                const nivel = s.progreso ? s.progreso.nivel_actual : 1;
                const puntos = s.progreso ? s.progreso.puntuacion_acumulada : 0;

                row.innerHTML = `
                    <div class="session-info">
                        <span class="session-name">${escapeHtml(s.alias)}</span>
                        <span class="session-sub">Nivel ${nivel} • ${puntos} pts • UUID: ${s.id.substring(0, 8)}...</span>
                    </div>
                    <button class="btn-delete-row" title="Eliminar registro de BD" onclick="deleteSession(event, '${s.id}')">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="3 6 5 6 21 6"/>
                            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
                        </svg>
                    </button>
                `;
                container.appendChild(row);
            });
        }

        function selectSession(id) {
            const found = dbSessionsList.find(s => s.id === id);
            if (!found) return;

            currentSession.id = found.id;
            currentSession.alias = found.alias;
            currentSession.nivel = found.progreso ? found.progreso.nivel_actual : 1;
            currentSession.puntos = found.progreso ? found.progreso.puntuacion_acumulada : 0;
            currentSession.tiempo = found.progreso ? found.progreso.tiempo_jugado_segundos : 0;
            currentSession.estadoJson = (found.progreso && found.progreso.estado_json) ? found.progreso.estado_json : {};

            document.getElementById('input-alias').value = currentSession.alias;
            renderSessionsList(dbSessionsList);
            updateUI();
            addLog(`Sesión ${found.alias} (${found.id.substring(0, 8)}...) seleccionada.`);
        }

        function filtrarRegistros() {
            const q = document.getElementById('search-box').value.toLowerCase();
            const filtered = dbSessionsList.filter(s => s.alias.toLowerCase().includes(q) || s.id.toLowerCase().includes(q));
            renderSessionsList(filtered);
        }

        // Acciones con la API de Laravel y PostgreSQL
        async function iniciarSesion() {
            const alias = document.getElementById('input-alias').value.trim() || 'Corian';
            addLog(`Enviando POST /api/juego/sesion para "${alias}"...`);

            try {
                const res = await fetch('/api/juego/sesion', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                    body: JSON.stringify({ alias: alias, dispositivo_uuid: 'Panel-Web-Client' })
                });

                const data = await res.json();
                if (res.status === 201) {
                    showToast('✨ Jugador registrado en PostgreSQL');
                    addLog(`Jugador creado con éxito. UUID: ${data.jugador.id}`);
                    await fetchAllRecords();
                    selectSession(data.jugador.id);
                }
            } catch (err) {
                addLog('Error al iniciar sesión: ' + err.message);
            }
        }

        async function guardarEnPostgreSQL() {
            if (!currentSession.id) return alert('Selecciona o crea una sesión primero.');

            addLog(`Enviando PUT /api/juego/progreso/${currentSession.id.substring(0,8)}...`);

            try {
                const res = await fetch(`/api/juego/progreso/${currentSession.id}`, {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                    body: JSON.stringify({
                        nivel_actual: currentSession.nivel,
                        puntuacion_acumulada: currentSession.puntos,
                        tiempo_jugado_segundos: currentSession.tiempo,
                        estado_json: currentSession.estadoJson
                    })
                });

                if (res.ok) {
                    showToast('💾 Datos y JSONB persistidos en PostgreSQL');
                    addLog('Progreso y JSONB guardados correctamente en la base de datos.');
                    await fetchAllRecords();
                }
            } catch (err) {
                addLog('Error guardando en BD: ' + err.message);
            }
        }

        async function recargarDesdePostgreSQL() {
            if (!currentSession.id) return;

            addLog(`Consultando GET /api/juego/progreso/${currentSession.id.substring(0,8)}...`);
            try {
                const res = await fetch(`/api/juego/progreso/${currentSession.id}`);
                const data = await res.json();
                if (res.ok) {
                    currentSession.nivel = data.progreso.nivel_actual;
                    currentSession.puntos = data.progreso.puntuacion_acumulada;
                    currentSession.tiempo = data.progreso.tiempo_jugado_segundos;
                    currentSession.estadoJson = data.progreso.estado_json;
                    updateUI();
                    showToast('🔄 Datos actualizados desde PostgreSQL');
                    addLog('Datos frescos descargados directamente de PostgreSQL.');
                }
            } catch (err) {
                addLog('Error al recargar: ' + err.message);
            }
        }

        async function deleteSession(e, id) {
            e.stopPropagation();
            if (!confirm('¿Eliminar este registro de PostgreSQL?')) return;

            try {
                const res = await fetch(`/api/juego/jugador/${id}`, {
                    method: 'DELETE',
                    headers: { 'Accept': 'application/json' }
                });

                if (res.ok) {
                    showToast('🗑️ Registro eliminado de la base de datos');
                    if (currentSession.id === id) currentSession.id = null;
                    await fetchAllRecords();
                }
            } catch (err) {
                addLog('Error eliminando registro: ' + err.message);
            }
        }

        // Simulaciones locales
        function simularMision() {
            currentSession.puntos += 150;
            currentSession.tiempo += 60;
            if (!currentSession.estadoJson.inventario) currentSession.estadoJson.inventario = {};
            const items = ['cristal_atlantis', 'reliquia_antigua', 'mapa_estelar'];
            const item = items[Math.floor(Math.random() * items.length)];
            currentSession.estadoJson.inventario[item] = (currentSession.estadoJson.inventario[item] || 0) + 1;
            addLog(`Misión completada: +150 pts y se añadió ${item} a estado_json.`);
            updateUI();
        }

        function simularSubidaNivel() {
            currentSession.nivel += 1;
            currentSession.puntos += 500;
            currentSession.estadoJson.capitulo = `Capítulo ${currentSession.nivel}: Ruinas de Atl`;
            addLog(`Subiste al nivel ${currentSession.nivel}.`);
            updateUI();
        }

        function simularDecisionEtica(tipo) {
            if (!currentSession.estadoJson.metricas_serious_game) {
                currentSession.estadoJson.metricas_serious_game = { indice_empatia: 70, decisiones: [] };
            }

            if (tipo === 'comunidad') {
                currentSession.estadoJson.metricas_serious_game.indice_empatia = Math.min(100, currentSession.estadoJson.metricas_serious_game.indice_empatia + 15);
                currentSession.estadoJson.metricas_serious_game.decisiones.push('Decisión: Compartir recursos con la aldea');
                currentSession.puntos += 300;
                addLog(`Decisión Altruista registrada en JSONB. Empatía: ${currentSession.estadoJson.metricas_serious_game.indice_empatia}%.`);
            } else {
                currentSession.estadoJson.metricas_serious_game.indice_empatia = Math.max(0, currentSession.estadoJson.metricas_serious_game.indice_empatia - 10);
                currentSession.estadoJson.metricas_serious_game.decisiones.push('Decisión: Acumular poder individual');
                currentSession.puntos += 100;
                addLog(`Decisión Individual registrada en JSONB.`);
            }
            updateUI();
        }

        function escapeHtml(str) {
            return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
        }

        // Inicializar al cargar
        window.addEventListener('load', fetchAllRecords);
    </script>
</body>
</html>
