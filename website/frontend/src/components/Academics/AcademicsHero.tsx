import { motion } from 'framer-motion';

export default function AcademicsHero() {
  return (
    <section className="relative pt-[108px] pb-24 overflow-hidden min-h-[60vh] flex items-center bg-brand-primary">
      {/* Background Image with Premium Overlay */}
      <div className="absolute inset-0 z-0">
        <img 
          src="/legends_bg.jpg" 
          alt="Legends in their fields" 
          className="w-full h-full object-cover opacity-80 scale-105"
        />
        <div className="absolute inset-0 bg-gradient-to-r from-brand-primary via-brand-primary/80 to-transparent"></div>
        <div className="absolute inset-0 bg-gradient-to-t from-brand-primary via-transparent to-transparent"></div>
        
        {/* Decorative Light Flares */}
        <div className="absolute top-0 right-1/4 w-[600px] h-[600px] bg-brand-accent/20 rounded-full blur-[120px] mix-blend-screen opacity-50"></div>
        <div className="absolute bottom-0 left-0 w-[400px] h-[400px] bg-white/5 rounded-full blur-[100px] mix-blend-screen opacity-50"></div>
      </div>
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10 w-full">
        <div className="max-w-3xl">
          <motion.div
            initial={{ opacity: 0, x: -50 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.8, ease: "easeOut" }}
          >
            <div className="inline-flex items-center space-x-3 mb-8">
              <span className="w-12 h-px bg-brand-accent"></span>
              <span className="text-xs font-bold tracking-[0.4em] text-brand-accent uppercase">
                Excellence in Learning
              </span>
            </div>
            
            <h1 className="text-[clamp(2.5rem,7vh,5rem)] font-serif font-bold text-white tracking-tighter leading-[1.05] mb-8">
              Academy of <br />
              <span className="text-brand-accent italic font-light drop-shadow-lg">Structure & Growth</span>
            </h1>
            
            <p className="max-w-xl text-white/70 font-light text-[clamp(1rem,2vh,1.25rem)] leading-relaxed border-l-2 border-brand-accent/30 pl-6 mb-10">
              Our academic framework is designed to spark intellectual curiosity while maintaining a rigorous focus on core mastery and character development. We prepare students not just for exams, but for life.
            </p>
            
          </motion.div>
        </div>
      </div>
    </section>
  );
}
