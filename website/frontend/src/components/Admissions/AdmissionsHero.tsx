import { motion } from 'framer-motion';
import { ArrowRight } from 'lucide-react';

const AdmissionsHero = () => {
  const scrollToForm = () => {
    const formElement = document.getElementById('admission-form');
    if (formElement) {
      formElement.scrollIntoView({ behavior: 'smooth' });
    }
  };

  return (
    <section className="relative min-h-[600px] h-screen flex items-center bg-brand-primary overflow-hidden">
      {/* Background Image with Elite Overlay */}
      <div className="absolute inset-0 z-0">
        <img 
          src="/admissions_hero_final_v5.png" 
          alt="Admissions at City Educational" 
          className="w-full h-full object-cover"
        />
        {/* Elite Gradient Overlay for Text Readability */}
        <div className="absolute inset-0 bg-gradient-to-r from-brand-primary via-brand-primary/80 to-transparent"></div>
        
        {/* Ambient Glow */}
        <div className="absolute top-1/2 left-0 -translate-y-1/2 w-[600px] h-[600px] bg-brand-accent/10 rounded-full blur-[120px] opacity-30 hidden sm:block"></div>
      </div>

      <div className="relative z-10 w-full max-w-7xl mx-auto px-6 pt-20">
        <motion.div
          initial={{ opacity: 0, x: -50 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 1.2, ease: "easeOut" }}
          className="max-w-2xl"
        >
          {/* Top Label - Premium Style */}
          <div className="inline-block px-5 py-2 rounded-full border border-brand-accent/40 bg-brand-accent/5 text-brand-accent font-black text-[10px] tracking-[0.3em] uppercase mb-8">
            Admissions 2026–27 Open
          </div>
          
          <h1 className="text-[clamp(2.5rem,8vh,4.5rem)] text-white font-serif font-bold leading-[1.1] tracking-tight mb-8">
            Join the <br/>
            <span className="text-brand-accent italic">Legacy</span> of <br/>
            Excellence.
          </h1>
          
          {/* Elite Accent Line */}
          <div className="w-48 h-[3px] bg-gradient-to-r from-brand-accent to-transparent mb-10 rounded-full"></div>
          
          <p className="text-lg md:text-xl text-white/80 font-medium max-w-xl leading-relaxed mb-12">
            Secure your child's future at City Educational Institutions. Our holistic curriculum, 
            expert faculty, and world-class campuses provide the perfect environment for growth.
          </p>

          <div className="flex flex-wrap gap-5 pb-10">
            <button 
              onClick={scrollToForm}
              className="px-10 py-5 bg-brand-accent text-white font-bold text-sm tracking-widest uppercase rounded-full shadow-2xl shadow-brand-accent/30 hover:scale-105 hover:bg-brand-accent/90 transition-all flex items-center gap-3 group"
            >
              Enquire Now
              <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
            </button>
            <button className="px-10 py-5 bg-brand-accent text-white font-bold text-sm tracking-widest uppercase rounded-full shadow-2xl shadow-brand-accent/30 hover:scale-105 hover:bg-brand-accent/90 transition-all flex items-center gap-3 group">
              Download Brochure
              <motion.span
                animate={{ y: [0, 2, 0] }}
                transition={{ repeat: Infinity, duration: 1.5 }}
              >
                <ArrowRight className="w-5 h-5 rotate-90" />
              </motion.span>
            </button>
          </div>
        </motion.div>
      </div>

      {/* Hero Scroll Decor similar to Management Hero */}
      <div className="absolute bottom-0 right-0 p-12 hidden lg:block">
        <div className="flex items-center gap-6">
          <div className="w-12 h-[1px] bg-white/20"></div>
          <span className="text-[10px] font-black text-white/40 tracking-[0.4em] uppercase vertical-text">
            Admissions Open
          </span>
        </div>
      </div>
    </section>
  );
};

export default AdmissionsHero;
