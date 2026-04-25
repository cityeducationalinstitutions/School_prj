import { motion } from 'framer-motion';

const ManagementHero = () => {
  return (
    <section className="relative min-h-[500px] h-[calc(100vh-140px)] max-h-[850px] flex items-center bg-brand-primary overflow-hidden">
      {/* Background Image with Elite Overlay */}
      <div className="absolute inset-0 z-0">
        <img 
          src="/management_hero.png" 
          alt="School Leadership" 
          className="w-full h-full object-cover opacity-70"
        />
        <div className="absolute inset-0 bg-gradient-to-r from-brand-primary via-brand-primary/60 to-transparent"></div>
        
        {/* Ambient Glow */}
        <div className="absolute top-1/2 left-0 -translate-y-1/2 w-[800px] h-[800px] bg-brand-accent/20 rounded-full blur-[160px] opacity-40 hidden sm:block"></div>
      </div>

      <div className="relative z-10 w-full max-w-7xl mx-auto px-6">
        <motion.div
          initial={{ opacity: 0, x: -50 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 1.2, ease: "easeOut" }}
          className="max-w-3xl"
        >
          <div className="inline-block px-5 py-2 rounded-full border border-brand-accent/40 bg-brand-accent/5 text-brand-accent font-black text-[10px] tracking-[0.3em] uppercase mb-8">
            Institutional Leadership
          </div>
          
          <h1 className="text-[clamp(1.75rem,7vh,4rem)] text-white font-serif font-bold leading-[1.05] tracking-tighter mb-8">
            The Pillars of <br />
            <span className="text-brand-accent">Our Institution</span>
          </h1>
         
          {/* Elite Accent Line */}
          <div className="w-48 h-[3px] bg-gradient-to-r from-brand-accent to-transparent mb-10 rounded-full"></div>
          
          <p className="text-lg md:text-2xl text-white/70 leading-relaxed max-w-2xl">
            Meet the visionaries who steer City Educational Institutions towards global excellence and academic leadership.
          </p>
        </motion.div>
      </div>

      {/* Hero Scroll Decor */}
      <div className="absolute bottom-0 right-0 p-12 hidden lg:block">
        <div className="flex items-center gap-6">
          <div className="w-12 h-[1px] bg-white/20"></div>
          <span className="text-[10px] font-black text-white/40 tracking-[0.4em] uppercase vertical-text">
            Legacy Excellence
          </span>
        </div>
      </div>
    </section>
  );
};

export default ManagementHero;
