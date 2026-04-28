import { motion } from 'framer-motion';

export default function AcademicModel() {
  const models = [
    { 
      icon: <img src="/3d_icon_flask.png" alt="Core Subjects" className="w-10 h-10 object-contain mix-blend-multiply drop-shadow-sm" />, 
      title: "Core Subjects", 
      desc: "A strong academic foundation built through a structured focus on English, Mathematics, Science, and Social Studies, ensuring clarity of concepts and long-term understanding.",
      featured: false
    },
    { 
      icon: <img src="/3d_icon_stars.png" alt="Personalized Guidance" className="w-10 h-10 object-contain mix-blend-multiply drop-shadow-sm" />, 
      title: "Personalized Guidance", 
      desc: "Individualized mentoring and tailored learning pathways designed to support each student’s unique pace, strengths, and academic goals.",
      featured: false
    },
    { 
      icon: <img src="/3d_icon_chart.png" alt="Weekly Assessments" className="w-10 h-10 object-contain mix-blend-multiply drop-shadow-sm" />, 
      title: "Weekly Assessments", 
      desc: "Continuous evaluation through regular assessments to monitor progress, reinforce learning, and ensure steady academic growth.",
      featured: false
    },
    { 
      icon: <img src="/3d_icon_team.png" alt="Project-Based Learning" className="w-10 h-10 object-contain mix-blend-multiply drop-shadow-sm" />, 
      title: "Project-Based Learning", 
      desc: "Hands-on learning experiences that encourage critical thinking, creativity, collaboration, and real-world problem-solving skills.",
      featured: false
    },
    { 
      icon: <img src="/3d_icon_clipboard.png" alt="Worksheets" className="w-10 h-10 object-contain mix-blend-multiply drop-shadow-sm" />, 
      title: "Worksheets", 
      desc: "Systematic practice through well-designed worksheets that strengthen conceptual clarity, improve accuracy, and build strong problem-solving abilities.",
      featured: false
    },
    { 
      icon: <img src="/3d_icon_telescope.png" alt="Advanced Research" className="w-10 h-10 object-contain mix-blend-multiply drop-shadow-sm" />, 
      title: "Advanced Research", 
      desc: "Early exposure to analytical thinking, structured inquiry, and scientific methods to develop curiosity, innovation, and future-ready learners.",
      featured: false
    }
  ];

  return (
    <section className="pt-4 pb-8 relative overflow-hidden bg-[#F8F9FB]">
      {/* Background Abstract Patterns */}
      <div className="absolute bottom-10 right-10 opacity-10 pointer-events-none">
        <div className="w-[300px] h-[300px] rounded-full border border-brand-primary/20"></div>
        <div className="w-[400px] h-[400px] rounded-full border border-brand-primary/20 absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2"></div>
      </div>

      <div className="max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="text-center mb-20 space-y-4">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.8 }}
          >
            <h2 className="text-[clamp(2rem,5.5vh,4rem)] font-serif text-brand-primary tracking-tight mb-4">
              Our Academic <span className="text-brand-accent italic">Model Includes</span>
            </h2>
            <p className="text-gray-500 font-medium max-w-3xl mx-auto text-lg leading-relaxed">
              A thoughtfully designed academic framework that combines wide-ranging exposure with focused depth to maximize every student’s potential.
            </p>
          </motion.div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 items-stretch">
          {models.map((item, idx) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: idx * 0.1, duration: 0.6 }}
              className={`group flex flex-col p-8 sm:p-10 rounded-[20px] transition-all duration-300 ease-in-out hover:-translate-y-2 hover:shadow-[0_20px_40px_rgb(0,0,0,0.08)] ${
                item.featured 
                  ? 'bg-gradient-to-br from-[#0B1E3C] to-[#1E3A8A] shadow-xl text-white' 
                  : 'bg-white shadow-[0_8px_30px_rgb(0,0,0,0.04)] text-brand-primary border border-transparent hover:border-gray-100'
              }`}
            >
              <div className={`w-16 h-16 rounded-full flex items-center justify-center mb-8 flex-shrink-0 transition-transform duration-300 group-hover:scale-110 ${
                item.featured 
                  ? 'bg-[#F28C38] shadow-lg shadow-brand-accent/30' 
                  : 'bg-gray-50'
              }`}>
                {item.icon}
              </div>
              <h3 className="text-2xl font-serif font-bold mb-4 text-brand-accent">
                {item.title}
              </h3>
              <p className={`font-medium leading-relaxed flex-1 ${item.featured ? 'text-gray-200' : 'text-gray-500'}`}>
                {item.desc}
              </p>
            </motion.div>
          ))}
        </div>

      </div>
    </section>
  );
}
