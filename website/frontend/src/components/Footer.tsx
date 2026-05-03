import { Link } from 'react-router-dom';
import { MapPin, ChevronRight } from 'lucide-react';

const Footer = () => {
  const currentYear = new Date().getFullYear();

  const footerLinks = {
    ourSchools: [
      { name: 'City Talent', path: '/schools#talent' },
      { name: 'New Vision', path: '/schools#new-vision' },
      { name: 'City Elite', path: '/schools#elite' },
    ],
    academicLife: [
      { name: 'Vision & Mission', path: '/about#vision' },
      { name: 'Codes & Policies', path: '/academics#policies' },
      { name: 'e-Prospectus', path: '/admissions#prospectus' },
    ],
    quickLinks: [
      { name: 'Curriculum', path: '/academics' },
      { name: 'Careers', path: '/careers' },
      { name: 'School Norms', path: '/about#norms' },
    ]
  };

  return (
    <footer className="bg-white pt-6 border-t border-gray-100 relative overflow-hidden">
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-6">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 lg:gap-8 items-center">
          
          {/* Column 1: Branding & Location */}
          <div className="flex flex-col items-center text-center space-y-6">
            <div className="flex flex-col items-center text-center">
              <img src="/school_logo.png" alt="School Logo" className="h-14 w-auto object-contain mb-2" />
              <div className="text-brand-primary font-serif font-bold text-lg tracking-tight">
                City Educational <br />
                <span className="text-brand-accent">Institutions</span>
              </div>
              <p className="text-base font-bold text-gray-400 mt-1 tracking-widest uppercase">Knowledge is Power</p>
            </div>
            
            <div className="space-y-2">
              <h4 className="text-sm font-bold text-brand-primary uppercase tracking-widest">Our Location</h4>
              <div className="w-full h-24 rounded-2xl overflow-hidden shadow-inner bg-gray-100 border border-gray-100">
                <iframe 
                  src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d15236.434538965037!2d79.6100!3d17.1432!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3a349bc67e0f279d%3A0x6b1cc8c5e6ee094a!2sSuryapet%2C%20Telangana!5e0!3m2!1sen!2sin!4v1713110000000" 
                  width="100%" 
                  height="100%" 
                  style={{ border: 0 }} 
                  allowFullScreen 
                  loading="lazy"
                ></iframe>
              </div>
            </div>

            <div className="space-y-3">
              <h4 className="text-sm font-bold text-brand-primary uppercase tracking-widest">Follow Us</h4>
              <div className="flex gap-3">
                {[
                  { 
                    icon: (
                      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z" />
                      </svg>
                    ), 
                    color: 'bg-[#1877F2]' 
                  },
                  { 
                    icon: (
                      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <rect width="20" height="20" x="2" y="2" rx="5" ry="5" />
                        <path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z" />
                        <line x1="17.5" x2="17.51" y1="6.5" y2="6.5" />
                      </svg>
                    ), 
                    color: 'bg-gradient-to-tr from-[#f9ce34] via-[#ee2a7b] to-[#6228d7]' 
                  },
                  { 
                    icon: (
                      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <path d="M2.5 17a24.12 24.12 0 0 1 0-10 2 2 0 0 1 1.4-1.4 49.56 49.56 0 0 1 16.2 0A2 2 0 0 1 21.5 7a24.12 24.12 0 0 1 0 10 2 2 0 0 1-1.4 1.4 49.56 49.56 0 0 1-16.2 0A2 2 0 0 1 2.5 17" />
                        <path d="m10 15 5-3-5-3z" />
                      </svg>
                    ), 
                    color: 'bg-[#FF0000]' 
                  }
                ].map((social, idx) => (
                  <a 
                    key={idx} 
                    href="#" 
                    className={`${social.color} text-white p-2.5 rounded-xl hover:scale-110 hover:rotate-3 transition-all duration-300 shadow-lg shadow-gray-200`}
                  >
                    {social.icon}
                  </a>
                ))}
              </div>
            </div>
          </div>

          {/* Column 2: Our Campus Locations */}
          <div className="flex flex-col items-center text-center">
            <h4 className="text-lg font-bold text-brand-primary uppercase tracking-widest mb-4 flex items-center justify-center gap-2">
              <MapPin className="w-4 h-4 text-brand-accent" />
              Our Campuses
            </h4>
            <ul className="space-y-2">
              {footerLinks.ourSchools.map((link, idx) => (
                <li key={idx}>
                  <Link 
                    to={link.path} 
                    className="text-gray-500 hover:text-brand-accent transition-colors flex items-center justify-center group text-lg"
                  >
                    <ChevronRight className="w-5 h-5 mr-2 text-brand-accent transform group-hover:translate-x-1 transition-transform" />
                    {link.name}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Column 3: Academic Life */}
          <div className="flex flex-col items-center text-center">
            <h4 className="text-lg font-bold text-brand-primary uppercase tracking-widest mb-4">Academic Life</h4>
            <ul className="space-y-2">
              {footerLinks.academicLife.map((link, idx) => (
                <li key={idx}>
                  <Link 
                    to={link.path} 
                    className="text-gray-500 hover:text-brand-accent transition-colors flex items-center justify-center group text-lg"
                  >
                    <ChevronRight className="w-5 h-5 mr-2 text-brand-accent transform group-hover:translate-x-1 transition-transform" />
                    {link.name}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Column 4: Quick Links */}
          <div className="flex flex-col items-center text-center">
            <h4 className="text-lg font-bold text-brand-primary uppercase tracking-widest mb-4">Quick Links</h4>
            <ul className="space-y-2">
              {footerLinks.quickLinks.map((link, idx) => (
                <li key={idx}>
                  <Link 
                    to={link.path} 
                    className="text-gray-500 hover:text-brand-accent transition-colors flex items-center justify-center group text-lg"
                  >
                    <ChevronRight className="w-5 h-5 mr-2 text-brand-accent transform group-hover:translate-x-1 transition-transform" />
                    {link.name}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

        </div>
      </div>

      {/* Copyright Bar */}
      <div className="bg-brand-primary py-4 text-center text-white/60 text-sm">
        <div className="max-w-7xl mx-auto px-4 flex flex-col md:flex-row justify-between items-center gap-2 border-t border-white/5 pt-2">
          <p>© {currentYear} City Educational Institutions. All Rights Reserved.</p>
          <div className="flex gap-6">
            <Link to="/privacy" className="hover:text-white transition-colors">Privacy Policy</Link>
            <Link to="/terms" className="hover:text-white transition-colors">Terms of Service</Link>
          </div>
        </div>
      </div>

    </footer>
  );
};

export default Footer;
