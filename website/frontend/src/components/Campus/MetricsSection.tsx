import { motion } from 'framer-motion';
import { Target, History, Users, Award } from 'lucide-react';


export default function MetricsSection() {
  const metrics = [
    { value: "95%", label: "Academic Results", icon: <Target className="w-5 h-5 text-brand-accent" /> },
    { value: "10+", label: "Years Excellence", icon: <History className="w-5 h-5 text-brand-accent" /> },
    { value: "1000+", label: "Enrolled Students", icon: <Users className="w-5 h-5 text-brand-accent" /> },
    { value: "50+", label: "Expert Faculty", icon: <Award className="w-5 h-5 text-brand-accent" /> },
  ];

  return (
    <section className="relative py-[clamp(4rem,10vh,8rem)] overflow-hidden group border-y border-brand-accent/10">
      {/* Background Image with Glassmorphism Overlay */}
      <div className="absolute inset-0 z-0">
        <img 
          src="/books_bg.png" 
          alt="Library Background" 
          className="w-full h-full object-cover transition-transform duration-1000 group-hover:scale-110"
        />
        <div className="absolute inset-0 bg-brand-accent/90 backdrop-blur-md"></div>
      </div>
      
      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-6 md:gap-8 text-center">
          {metrics.map((metric, idx) => (
            <motion.div 
              key={idx}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: idx * 0.1, duration: 0.5 }}
              className="flex flex-col items-center justify-center space-y-4"
            >
              {/* White Circle Icon Container */}
              <div className="w-12 h-12 bg-white rounded-full flex items-center justify-center shadow-lg transform transition-transform duration-300 hover:scale-110">
                {metric.icon}
              </div>

              <div className="space-y-1">
                <div className="text-2xl md:text-4xl font-serif text-white">{metric.value}</div>
                <div className="text-[10px] md:text-xs font-bold tracking-[0.2em] text-white/90 uppercase">{metric.label}</div>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}
