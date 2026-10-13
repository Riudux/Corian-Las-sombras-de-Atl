import React from 'react';
import './App.css';

// Componentes de Íconos SVG reutilizables
const MapPinIcon = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
);

const PhoneIcon = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
);

const MailIcon = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
);

const ChevronDownIcon = () => (
  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="m6 9 6 6 6-6"/></svg>
);

// Íconos de Redes Sociales
const InstagramIcon = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><rect width="20" height="20" x="2" y="2" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><line x1="17.5" x2="17.51" y1="6.5" y2="6.5"/></svg>
);

const FacebookIcon = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/></svg>
);

const XTwitterIcon = () => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/></svg>
);

const YoutubeIcon = () => (
  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M2.5 17a24.12 24.12 0 0 1 0-10 2 2 0 0 1 1.4-1.4 49.56 49.56 0 0 1 16.2 0A2 2 0 0 1 21.5 7a24.12 24.12 0 0 1 0 10 2 2 0 0 1-1.4 1.4 49.56 49.56 0 0 1-16.2 0A2 2 0 0 1 2.5 17z"/><path d="m10 15 5-3-5-3v6z"/></svg>
);

function App() {
  return (
    <div className="app-layout">
      {/* --- ENCABEZADO --- */}
      <header className="header">
        {/* Franja decorativa superior con los colores del logo */}
        <div className="header-color-bar"></div>

        <div className="header-container">
          <nav>
            <ul className="nav-menu">
              <li className="nav-item">
                <a href="#inicio" className="nav-link">Inicio</a>
              </li>

              {/* Menú: Consejo de Participación Ciudadana */}
              <li className="nav-item">
                <span className="nav-link">
                  Consejo de Participación Ciudadana <ChevronDownIcon />
                </span>
                <ul className="dropdown-menu">
                  <li className="dropdown-item"><a href="#quienes-somos">Quiénes somos</a></li>
                  <li className="dropdown-item"><a href="#identidad">Identidad</a></li>
                  <li className="dropdown-item"><a href="#normativa">Normativa y aportaciones</a></li>
                  <li className="dropdown-item"><a href="#convenios">Convenios de colaboración</a></li>
                  <li className="dropdown-item"><a href="#programas">Programas anuales de trabajo</a></li>
                  <li className="dropdown-item"><a href="#informes">Informes anuales</a></li>
                  <li className="dropdown-item"><a href="#actas">Actas de sesiones</a></li>
                </ul>
              </li>

              {/* Menú: Materiales Didácticos y Difusión */}
              <li className="nav-item">
                <span className="nav-link">
                  Materiales didácticos y difusión <ChevronDownIcon />
                </span>
                <ul className="dropdown-menu">
                  <li className="dropdown-item"><a href="#decalogo">Decálogo del sistema local anticorrupción</a></li>
                  <li className="dropdown-item"><a href="#campanas">Campañas</a></li>
                  <li className="dropdown-item"><a href="#seminarios">Seminarios</a></li>
                  <li className="dropdown-item"><a href="#te-guacho">"Te guacho, te cacho"</a></li>
                  <li className="dropdown-item"><a href="#spots">Spots de TV</a></li>
                  <li className="dropdown-item active"><a href="#juegos">Juegos interactivos</a></li>
                </ul>
              </li>

              {/* Menú: Transparencia */}
              <li className="nav-item">
                <span className="nav-link">
                  Transparencia <ChevronDownIcon />
                </span>
                <ul className="dropdown-menu">
                  <li className="dropdown-item"><a href="#transparencia-proactiva">Transparencia proactiva</a></li>
                  <li className="dropdown-item"><a href="#pnt">Plataforma Nacional de Transparencia</a></li>
                  <li className="dropdown-item"><a href="#transparencia-durango">Transparencia Durango</a></li>
                </ul>
              </li>

              <li className="nav-item">
                <a href="#red" className="nav-link">Red de Participación Ciudadana</a>
              </li>

              <li className="nav-item">
                <a href="#denuncia" className="nav-link">Denuncia</a>
              </li>
            </ul>
          </nav>

          {/* Espacio para imagen a la derecha del encabezado */}
          <div className="header-image-space">
            {/* Reemplazar src por la ruta real de la imagen/logotipo */}
            <img 
              src="https://via.placeholder.com/150x50?text=Logo+CPC" 
              alt="Logo Institucional" 
              className="header-logo-placeholder" 
            />
          </div>
        </div>
      </header>

      {/* --- ÁREA CENTRAL / SECCIÓN DE VIDEOJUEGOS --- */}
      <main className="main-content">
        <section className="game-section">
          <div className="game-section-header">
            <h1>Juegos Interactivos y Videojuegos</h1>
            <p>Aprende sobre la cultura de la transparencia y anticorrupción jugando.</p>
          </div>

          <div className="game-container-wrapper">
            <div className="game-canvas-placeholder">
              <h3>Área de Canvas / Contenedor del Videojuego</h3>
              <p>Aquí se integrará el desarrollo de tu videojuego o juego interactivo.</p>
              <button className="btn-play">Iniciar Juego</button>
            </div>
          </div>
        </section>
      </main>

      {/* --- PIE DE PÁGINA (FOOTER) --- */}
      <footer className="footer">
        {/* Espacio para 2 imágenes en el centro */}
        <div className="footer-top-images">
          <div className="footer-img-placeholder">
            <span>Imagen 1</span>
          </div>
          <div className="footer-img-placeholder">
            <span>Imagen 2</span>
          </div>
        </div>

        <div className="footer-content">
          <h2 className="footer-title">Contáctanos</h2>

          <p className="footer-description">
            Participa activamente en tu comunidad, evitando actos de corrupción. Haznos llegar tus comentarios o sugerencias por los siguientes medios:
          </p>

          <div className="footer-contact-details">
            <div className="contact-item">
              <span className="contact-icon"><MapPinIcon /></span>
              <span>C. Patoni 204. Col. Guillermina. Durango, Dgo. C.P. 34270.</span>
            </div>

            <div className="contact-item">
              <span className="contact-icon"><PhoneIcon /></span>
              <span>(618) 818 4913</span>
            </div>

            <div className="contact-item">
              <span className="contact-icon"><MailIcon /></span>
              <span>cpcdurango@outlook.com</span>
            </div>
          </div>

          <div className="footer-social-section">
            <h3 className="social-title">Redes Sociales</h3>
            <div className="social-icons">
              <a href="#instagram" className="social-btn instagram" aria-label="Instagram">
                <InstagramIcon />
              </a>
              <a href="#facebook" className="social-btn facebook" aria-label="Facebook">
                <FacebookIcon />
              </a>
              <a href="#x" className="social-btn x-twitter" aria-label="X (Twitter)">
                <XTwitterIcon />
              </a>
              <a href="#youtube" className="social-btn youtube" aria-label="YouTube">
                <YoutubeIcon />
              </a>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}

export default App;