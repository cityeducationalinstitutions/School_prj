import { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { Phone, Mail, Menu, X, ChevronDown } from 'lucide-react';
import { AnimatePresence, motion } from 'framer-motion';

export default function Navbar() {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const location = useLocation();
  const currentPath = location.pathname;

  const [activeDropdown, setActiveDropdown] = useState<string | null>(null);

  const navLinks = [
    { name: 'HOME', path: '/' },
    { 
      name: 'ABOUT US', 
      path: '/about',
      dropdown: [
        { name: 'Who We Are', path: '/about' },
        { name: 'Management', path: '/management' },
      ]
    },
    { 
      name: 'OUR CAMPUSES', 
      path: '/campuses/city-talent',
      dropdown: [
        { name: 'City Talent', path: '/campuses/city-talent' },
        { name: 'City Elite', path: '/campuses/city-elite' },
        { name: 'New Vision', path: '/campuses/new-vision' }
      ]
    },
    { name: 'ACADEMICS', path: '/academics' },
    { name: 'FACILITIES', path: '/facilities' },
    { name: 'GALLERY', path: '/gallery' },
  ];

  return (
    <div className="flex flex-col w-full z-50 sticky top-0 left-0 right-0">
      {/* Top Bar - Orange Brand Color */}
      <div className="bg-brand-accent text-white h-8 flex items-center text-[10px] lg:text-xs font-bold hidden lg:flex">
        <div className="max-w-7xl mx-auto w-full px-4 sm:px-6 lg:px-8 flex justify-between items-center gap-4 lg:gap-8">
          <div className="flex-grow overflow-hidden relative">
            <motion.div 
              animate={{ x: ["0%", "70%", "0%"] }}
              transition={{ 
                duration: 12, 
                repeat: Infinity, 
                ease: "linear",
              }}
              className="text-[11px] md:text-sm font-bold tracking-wide whitespace-nowrap"
            >
              శ్రమతో సర్వం సాధ్యం
            </motion.div>
          </div>
          <div className="flex items-center gap-4 lg:gap-8">
            <div className="flex items-center gap-2">
              <Phone className="w-3.5 h-3.5" />
              <span>+91 9393073773</span>
            </div>
            <div className="flex items-center gap-2 border-l border-white/30 pl-4 lg:pl-8">
              <Mail className="w-3.5 h-3.5" />
              <span>info@cityeducational.com</span>
            </div>
          </div>
        </div>
      </div>

      {/* Main Navigation Bar - White */}
      <header className="bg-white/95 backdrop-blur-xl shadow-[0_8px_32px_-12px_rgba(0,0,0,0.08)] border-b border-brand-accent/5 transition-all duration-500">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-6 xl:px-8">
          <div className="flex justify-between items-center h-[64px] xl:h-[76px]">
            
            {/* Logo area */}
            <div className="flex-shrink-0 flex items-center pr-2 lg:pr-4 xl:pr-8">
              <Link to="/" className="flex items-center gap-3 transition-transform hover:scale-[1.02]">
                <img src="/school_logo.png" alt="Logo" className="h-[38px] sm:h-[48px] w-auto object-contain" />
                <div className="flex flex-col hidden sm:flex">
                  <span className="font-serif text-[15px] lg:text-[16px] xl:text-[19px] font-bold text-brand-primary tracking-tight leading-none">CITY EDUCATIONAL</span>
                  <span className="text-[8px] sm:text-[10px] font-sans tracking-[0.3em] text-gray-500 font-medium mt-0.5 uppercase">Institutions</span>
                </div>
              </Link>
            </div>

            {/* Navigation Links */}
            <nav className="hidden lg:flex space-x-0.5 xl:space-x-4 flex-grow justify-center">
              {navLinks.map((link) => (
                <div 
                  key={link.name}
                  className="relative group"
                  onMouseEnter={() => link.dropdown && setActiveDropdown(link.name)}
                  onMouseLeave={() => link.dropdown && setActiveDropdown(null)}
                >
                  <Link 
                    to={link.path} 
                    className={`relative px-1.5 xl:px-3 py-4 text-[10px] xl:text-sm font-bold tracking-wider transition-colors duration-300 flex items-center gap-1 whitespace-nowrap ${
                      (currentPath === link.path || link.dropdown?.some(sub => currentPath === sub.path)) 
                        ? 'text-brand-accent' 
                        : 'text-gray-600 hover:text-brand-accent'
                    }`}
                  >
                    {link.name}
                    {link.dropdown && (
                      <ChevronDown className={`w-4 h-4 transition-transform duration-300 ${activeDropdown === link.name ? 'rotate-180' : ''}`} />
                    )}
                  </Link>

                  {/* Desktop Dropdown */}
                  {link.dropdown && (
                    <AnimatePresence>
                      {activeDropdown === link.name && (
                        <motion.div
                          initial={{ opacity: 0, y: 10 }}
                          animate={{ opacity: 1, y: 0 }}
                          exit={{ opacity: 0, y: 10 }}
                          transition={{ duration: 0.2 }}
                          className="absolute left-1/2 -translate-x-1/2 top-full w-48 bg-white/95 backdrop-blur-xl border border-gray-100 shadow-xl rounded-2xl py-3 z-50"
                        >
                          {link.dropdown.map((subItem) => (
                            <Link
                              key={subItem.name}
                              to={subItem.path}
                              className={`block px-6 py-3 text-xs font-bold tracking-wide transition-colors ${
                                currentPath === subItem.path ? 'bg-brand-accent/10 text-brand-accent' : 'text-gray-600 hover:bg-gray-50 hover:text-brand-accent'
                              }`}
                            >
                              {subItem.name}
                            </Link>
                          ))}
                        </motion.div>
                      )}
                    </AnimatePresence>
                  )}
                </div>
              ))}
            </nav>

            {/* Right Side CTA */}
            <div className="hidden lg:flex items-center pl-2 xl:pl-8">
              <Link 
                to="/admissions" 
                className="glow-on-hover inline-flex items-center justify-center px-3 xl:px-6 py-2 xl:py-2.5 text-[10px] xl:text-sm font-bold rounded-full text-white bg-brand-accent transition-all shadow-lg shadow-brand-accent/20 tracking-wide uppercase group/cta overflow-hidden whitespace-nowrap"
              >
                <span className="relative z-10">Admission 2026-27</span>
                <div className="absolute inset-0 bg-white/20 translate-y-full group-hover/cta:translate-y-0 transition-transform duration-500"></div>
              </Link>
            </div>

            {/* Mobile Menu Button */}
            <div className="lg:hidden flex items-center pr-2">
              <button 
                onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
                className="text-brand-primary p-2.5 focus:outline-none hover:bg-brand-accent/5 rounded-2xl transition-all border border-transparent active:border-brand-accent/20"
                aria-label="Toggle mobile menu"
              >
                {isMobileMenuOpen ? <X className="w-6 h-6 text-brand-accent" /> : <Menu className="w-6 h-6" />}
              </button>
            </div>
            
          </div>
        </div>

        {/* Mobile Navigation Menu Dropdown */}
        <AnimatePresence>
          {isMobileMenuOpen && (
            <motion.div 
              initial={{ opacity: 0, height: 0 }}
              animate={{ opacity: 1, height: 'auto' }}
              exit={{ opacity: 0, height: 0 }}
              className="lg:hidden bg-white/95 backdrop-blur-xl border-t border-brand-accent/10 absolute left-0 w-full shadow-2xl z-50 overflow-hidden"
            >
              <div className="flex flex-col px-6 pt-4 pb-10 space-y-1">
                {navLinks.map((link) => (
                  <div key={link.name} className="flex flex-col">
                    {link.dropdown ? (
                      <>
                        <div className="px-4 py-4 text-[10px] font-black text-brand-accent/60 tracking-[0.3em] uppercase mt-4 first:mt-0">
                          {link.name}
                        </div>
                        <div className="flex flex-col space-y-1">
                          {link.dropdown.map((sub) => (
                            <Link 
                              key={sub.name}
                              to={sub.path}
                              onClick={() => setIsMobileMenuOpen(false)}
                              className={`px-4 py-3.5 text-sm font-bold tracking-wider rounded-xl transition-all flex items-center justify-between ${
                                currentPath === sub.path ? 'bg-brand-accent/10 text-brand-accent' : 'text-gray-600 active:bg-gray-50'
                              }`}
                            >
                              {sub.name}
                              {currentPath === sub.path && <div className="w-1.5 h-1.5 rounded-full bg-brand-accent"></div>}
                            </Link>
                          ))}
                        </div>
                      </>
                    ) : (
                      <Link 
                        to={link.path}
                        onClick={() => setIsMobileMenuOpen(false)}
                        className={`px-4 py-4 text-sm font-bold tracking-wider rounded-xl transition-all flex items-center justify-between mt-2 first:mt-0 ${
                          currentPath === link.path ? 'bg-brand-accent/10 text-brand-accent' : 'text-gray-600 active:bg-gray-50'
                        }`}
                      >
                        {link.name}
                        {currentPath === link.path && <div className="w-1.5 h-1.5 rounded-full bg-brand-accent"></div>}
                      </Link>
                    )}
                  </div>
                ))}
                <div className="pt-8">
                  <Link 
                    to="/admissions" 
                    onClick={() => setIsMobileMenuOpen(false)}
                    className="block w-full text-center px-5 py-4 text-xs font-black rounded-full text-white bg-brand-accent shadow-lg shadow-brand-accent/20 tracking-[0.2em] uppercase transition-transform active:scale-95"
                  >
                    Admission 2026-27
                  </Link>
                </div>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </header>
    </div>
  );
}
