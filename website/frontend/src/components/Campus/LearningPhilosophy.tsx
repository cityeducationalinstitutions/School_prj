import { motion } from 'framer-motion';
import idea3d from '../../assets/icons/idea_3d_v2.png';
import compass3d from '../../assets/icons/compass_3d_v2.png';
import users3d from '../../assets/icons/users_3d_v2.png';
import heart3d from '../../assets/icons/heart_3d_v2.png';

interface PhilosophyItem {
  icon: React.ReactNode;
  title: string;
  desc: string;
}

export default function LearningPhilosophy({ 
  description = "Education goes beyond the textbooks. At City Talent, we build the foundation for critical thinking, empathy, and resilience.",
  items
}: { 
  description?: string;
  items?: PhilosophyItem[];
}) {
  const defaultPhilosophies = [
    {
      icon: <img src={idea3d} alt="Concept-based" className="w-10 h-10 object-contain scale-[1.7]" />,
      title: "Concept-based Learning",
      desc: "Focusing on core ideas rather than rote memorization to ensure deep, transferable knowledge."
    },
    {
      icon: <img src={compass3d} alt="Practical" className="w-10 h-10 object-contain scale-[1.7]" />,
      title: "Practical Understanding",
      desc: "Connecting classroom theories to real-world applications and hands-on experiences."
    },
    {
      icon: <img src={users3d} alt="Engagement" className="w-10 h-10 object-contain scale-[1.7]" />,
      title: "Student Engagement",
      desc: "Fostering active participation, curiosity, and a lifelong love for independent learning."
    },
    {
      icon: <img src={heart3d} alt="Holistic" className="w-10 h-10 object-contain scale-[1.7]" />,
      title: "Holistic Development",
      desc: "Nurturing emotional intelligence, physical well-being, and strong moral character."
    }
  ];

  const philosophies = items || defaultPhilosophies;

  return (
    <section className="py-[clamp(4rem,10vh,8rem)] bg-brand-light relative overflow-hidden">
      {/* Background Decorative Elements */}
      <div className="absolute top-0 right-0 w-[600px] h-[600px] bg-brand-accent/5 rounded-full blur-[120px] -z-10 translate-x-1/2 -translate-y-1/2 opacity-60 hidden sm:block"></div>
      <div className="absolute bottom-0 left-0 w-[400px] h-[400px] bg-brand-primary/5 rounded-full blur-[100px] -z-10 -translate-x-1/2 translate-y-1/2 opacity-40 hidden sm:block"></div>
      
      {/* Architecture Line Decor */}
      <div className="absolute top-1/4 left-0 w-full h-px bg-gradient-to-r from-transparent via-brand-accent/10 to-transparent -z-10"></div>
      <div className="absolute top-2/4 left-0 w-full h-px bg-gradient-to-r from-transparent via-brand-accent/5 to-transparent -z-10"></div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="flex flex-col lg:flex-row gap-20">
          
          {/* Header Section */}
          <motion.div 
            initial={{ opacity: 0, x: -30 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            className="lg:w-1/3 relative"
          >
            <div className="relative z-10 pt-8">
              <span className="inline-block py-1.5 px-5 rounded-full border border-brand-accent/30 bg-brand-accent/5 text-brand-accent font-black text-[10px] tracking-[0.3em] uppercase mb-8">
                Our Core Values
              </span>
              <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif text-brand-primary leading-[0.9] tracking-tighter mb-10">
                Our Learning <br/> 
                <span className="text-brand-accent drop-shadow-sm">Philosophy.</span>
              </h2>
              <p className="text-gray-500 text-base sm:text-xl leading-relaxed border-l-2 border-brand-accent/20 pl-6">
                {description}
              </p>
            </div>
          </motion.div>
          
          {/* Cards Grid */}
          <div className="lg:w-2/3 grid grid-cols-1 sm:grid-cols-2 gap-8 lg:pt-12">
            {philosophies.map((item) => (
              <div className="group relative bg-white/60 backdrop-blur-sm p-6 sm:p-10 border border-white shadow-[0_20px_50px_-12px_rgba(0,0,0,0.05)] transition-all duration-500 rounded-[2rem] sm:rounded-[3rem] overflow-hidden">
                <div className="relative z-10">
                  <div className="mb-8 w-16 h-16 rounded-2xl bg-brand-accent/10 flex items-center justify-center transition-all duration-500 shadow-inner">
                    <div className="text-brand-accent transition-colors duration-500">
                      {item.icon}
                    </div>
                  </div>
                  
                  <h3 className="text-2xl font-serif font-bold mb-5 text-brand-accent transition-colors duration-500 tracking-tight">
                    {item.title}
                  </h3>
                  
                  <p className="text-gray-500 leading-relaxed text-sm lg:text-base transition-colors duration-500">
                    {item.desc}
                  </p>
                </div>
              </div>
            ))}
          </div>

        </div>
      </div>
    </section>
  );
}
