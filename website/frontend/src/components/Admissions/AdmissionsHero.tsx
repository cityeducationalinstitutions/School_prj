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
    <section className="relative min-h-[500px] h-[calc(100vh-140px)] max-h-[850px] flex items-center pt-16 overflow-hidden bg-brand-primary">
      {/* Background Image with Overlay */}
      <div className="absolute inset-0 z-0">
        <img 
          src="/academics_students.png" 
          alt="Admissions at City Educational" 
          className="w-full h-full object-cover opacity-60"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-brand-primary via-brand-primary/40 to-transparent"></div>
      </div>

      <div className="relative z-10 w-full max-w-7xl mx-auto px-6">
        <motion.div
          initial={{ opacity: 0, x: -30 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 1 }}
          className="max-w-4xl"
        >
          <span className="inline-block py-1.5 px-5 rounded-full border border-brand-accent/30 bg-brand-accent/5 text-brand-accent font-black text-[10px] tracking-[0.3em] uppercase mb-8">
            Admissions 2026-27 Open
          </span>
          
          <h1 className="text-[clamp(2rem,7vh,5rem)] text-white font-serif font-bold leading-[1] tracking-tighter mb-8">
            Join the <br/>
            <span className="text-brand-accent italic font-light drop-shadow-sm leading-tight">Legacy of Excellence.</span>
          </h1>
          
          {/* Accent Line */}
          <div className="w-48 h-[2px] bg-white/40 mb-10"></div>
          
          <p className="text-lg md:text-xl text-white/80 font-light max-w-2xl leading-relaxed mb-12">
            Secure your child's future at City Educational Institutions. Our holistic curriculum, 
            expert faculty, and world-class campuses provide the perfect environment for growth.
          </p>

          <div className="flex flex-wrap gap-6">
            <button 
              onClick={scrollToForm}
              className="px-10 py-5 bg-brand-accent text-white font-bold text-sm tracking-widest uppercase rounded-full shadow-2xl shadow-brand-accent/30 hover:scale-105 hover:bg-brand-accent/90 transition-all flex items-center gap-3 group"
            >
              Enquire Now
              <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
            </button>
            <button className="px-10 py-5 glass-card border-white/20 text-white font-bold text-sm tracking-widest uppercase rounded-full hover:bg-white/10 transition-all">
              Download Brochure
            </button>
          </div>
        </motion.div>
      </div>
    </section>
  );
};

export default AdmissionsHero;
