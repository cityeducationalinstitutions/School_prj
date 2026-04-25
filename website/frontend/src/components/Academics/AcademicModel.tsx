import { motion } from 'framer-motion';
import { Book, Globe, LineChart, Group, Stars, Microscope } from 'lucide-react';

export default function AcademicModel() {
  const models = [
    { 
      icon: <Microscope className="w-8 h-8 text-white" />, 
      title: "Core Subjects", 
      text: "Comprehensive focus on English, Mathematics, Science, and Social Studies." 
    },
    { 
      icon: <Globe className="w-8 h-8 text-white" />, 
      title: "Global Languages", 
      text: "Diverse language options and cultural enrichment activities for a global perspective." 
    },
    { 
      icon: <LineChart className="w-8 h-8 text-white" />, 
      title: "Weekly Assessments", 
      text: "Continuous performance reviews to ensure consistent growth and skill mastery." 
    },
    { 
      icon: <Group className="w-8 h-8 text-white" />, 
      title: "Project-Based Learning", 
      text: "Hands-on collaborative activity to solve real-world problems and develop teamwork." 
    },
    { 
      icon: <Stars className="w-8 h-8 text-white" />, 
      title: "Personalized Guidance", 
      text: "Remedial modules and custom roadmaps tailored to each child's unique needs." 
    },
    { 
      icon: <Book className="w-8 h-8 text-white" />, 
      title: "Advanced Research", 
      text: "Early exposure to scientific method and structured academic research principles." 
    }
  ];

  return (
    <section className="py-[clamp(4rem,10vh,8rem)] bg-brand-light px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-20">
          <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif font-bold text-brand-primary tracking-tighter mb-4">
            Our Academic <span className="text-brand-accent italic font-light">Model Includes</span>
          </h2>
          <p className="text-gray-500 font-light max-w-2xl mx-auto italic text-lg leading-relaxed">
            A multi-layered design ensuring both broad coverage and deep specialization.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {models.map((item, idx) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: idx * 0.1 }}
              className="bg-white p-6 sm:p-10 rounded-[2rem] sm:rounded-[3rem] shadow-elite hover:shadow-2xl transition-all duration-500 group border border-transparent hover:border-brand-accent/20"
            >
              <div className="w-16 h-16 rounded-2xl bg-brand-primary flex items-center justify-center mb-8 shadow-inner group-hover:bg-brand-accent transition-colors duration-500">
                {item.icon}
              </div>
              <h3 className="text-2xl font-serif font-bold text-brand-primary mb-4">{item.title}</h3>
              <p className="text-gray-600 font-light leading-relaxed">{item.text}</p>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}
