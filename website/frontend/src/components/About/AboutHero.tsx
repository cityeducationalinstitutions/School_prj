import { motion } from 'framer-motion';

interface AboutHeroProps {
  title: string;
  subtitle: string;
  description: string;
  image?: string;
}

const AboutHero = ({ title, subtitle, description, image = "/about_hero_wonderla.jpg" }: AboutHeroProps) => {
  return (
    <section className="relative min-h-[500px] h-screen max-h-[850px] flex items-start pt-[18vh] lg:pt-[22vh] overflow-hidden bg-[#0A1F44]">
      {/* 1. Background Layer: Overall Background Image */}
      <div className="absolute inset-0 z-0">
        <img 
          src={image} 
          alt={title} 
          className="w-full h-full object-cover object-center"
          style={{ filter: 'brightness(0.95) contrast(1.05)' }}
        />
        
        {/* 2. Cinematic Gradient Overlay (Left to Right) */}
        <div 
          className="absolute inset-0 z-10"
          style={{
            background: `linear-gradient(
              to right,
              rgba(10, 31, 68, 0.95) 0%,
              rgba(10, 31, 68, 0.85) 25%,
              rgba(10, 31, 68, 0.6) 50%,
              rgba(10, 31, 68, 0.3) 75%,
              rgba(10, 31, 68, 0.1) 100%
            )`
          }}
        ></div>
      </div>

      {/* 3. Content Layer: Positioned on the Left */}
      <div className="relative z-20 w-full max-w-7xl mx-auto px-6 md:px-20 lg:px-24">
        <motion.div
          initial={{ opacity: 0, x: -40 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 1.2, ease: "easeOut" }}
          className="max-w-2xl"
        >
          {/* Label Section */}
          <p className="text-[#F28C38] font-serif text-2xl mb-1 tracking-wide font-medium">
            {title}
          </p>
          
          {/* Heading Section */}
          <h1 className="text-[clamp(2.5rem,8vh,5rem)] font-serif font-bold leading-[1.05] tracking-tight text-white mb-8">
            <span className="block mb-2 drop-shadow-lg">
              {subtitle.split(' ').slice(0, 2).join(' ')}
            </span>
            <span className="text-[#F28C38] drop-shadow-lg">
              {subtitle.split(' ').slice(2).join(' ')}
            </span>
          </h1>
          
          {/* Subtle Horizontal Divider */}
          <div className="w-48 h-[1px] bg-white/10 mb-8"></div>
          
          {/* Description Section */}
          <p className="text-lg md:text-xl text-white/95 max-w-xl leading-relaxed mb-8 font-light tracking-wide drop-shadow-md">
            {description}
          </p>


        </motion.div>
      </div>
    </section>
  );
};

export default AboutHero;
