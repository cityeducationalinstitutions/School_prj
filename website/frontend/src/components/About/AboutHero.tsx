import { motion } from 'framer-motion';

interface AboutHeroProps {
  title: string;
  subtitle: string;
  description: string;
  image?: string;
}

const AboutHero = ({ title, subtitle, description, image = "/about_hero.png" }: AboutHeroProps) => {
  return (
    <section className="relative min-h-[500px] h-[calc(100vh-140px)] max-h-[850px] flex items-center pt-16 overflow-hidden bg-brand-primary">
      {/* Background Image with Overlay */}
      <div className="absolute inset-0 z-0">
        <img 
          src={image} 
          alt={title} 
          className="w-full h-full object-cover object-top opacity-60"
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
          <h1 className="text-[clamp(1.75rem,7vh,4.5rem)] text-white font-serif font-bold leading-[1.05] tracking-tighter mb-6">
            {title} <br/>
            <span className="text-brand-accent drop-shadow-sm leading-tight">{subtitle}</span>
          </h1>
          
          {/* Accent Line */}
          <div className="w-48 h-[2px] bg-white/40 mb-8"></div>
          
          <p className="text-lg md:text-xl text-white/80 max-w-3xl leading-relaxed">
            {description}
          </p>
        </motion.div>
      </div>
    </section>
  );
};

export default AboutHero;
