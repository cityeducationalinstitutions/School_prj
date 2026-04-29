import { motion } from 'framer-motion';

export default function CurriculumSection() {
  const cardsLeft = [
    { 
      title: "Academic Mastery", 
      desc: "We build a strong academic foundation through structured learning, conceptual clarity, and consistent performance. Our approach ensures students develop depth in knowledge, not just surface-level understanding.",
      icon: <img src="/3d_icon_graduation.png" alt="Graduation Cap" className="w-11 h-11 object-contain mix-blend-multiply drop-shadow-sm" />,
      iconBg: "bg-orange-50/50",
      borderColor: "border-l-[6px] border-l-brand-accent",
      lineColor: "bg-brand-accent"
    },
    { 
      title: "Critical Thinking", 
      desc: "We cultivate analytical thinking and problem-solving abilities by encouraging students to question, explore, and innovate. Learning goes beyond memorization to real understanding and application.",
      icon: <img src="/3d_icon_lightbulb.png" alt="Lightbulb" className="w-11 h-11 object-contain mix-blend-multiply drop-shadow-sm" />,
      iconBg: "bg-orange-50/50",
      borderColor: "border-l-[6px] border-l-brand-accent",
      lineColor: "bg-brand-accent"
    },
    { 
      title: "Continuous Learning", 
      desc: "We inspire a lifelong love for learning by nurturing curiosity and intellectual growth. Students are empowered to seek knowledge beyond textbooks and adapt to an ever-evolving world.",
      icon: <img src="/3d_icon_book.png" alt="Book" className="w-11 h-11 object-contain mix-blend-multiply drop-shadow-sm" />,
      iconBg: "bg-orange-50/50",
      borderColor: "border-l-[6px] border-l-brand-accent",
      lineColor: "bg-brand-accent"
    }
  ];

  const cardsRight = [
    { 
      title: "Character Formation", 
      desc: "We instill discipline, integrity, and strong moral values that shape responsible individuals. Our focus is on developing character alongside academic excellence.",
      icon: <img src="/3d_icon_shield.png" alt="Shield" className="w-11 h-11 object-contain mix-blend-multiply drop-shadow-sm" />,
      iconBg: "bg-orange-50/50",
      borderColor: "border-r-[6px] border-r-brand-accent",
      lineColor: "bg-brand-accent"
    },
    { 
      title: "Digital Literacy", 
      desc: "We equip students with essential digital skills and technological awareness to thrive in a modern, connected world. Learning integrates tools that enhance creativity and productivity.",
      icon: <img src="/3d_icon_computer.png" alt="Computer" className="w-11 h-11 object-contain mix-blend-multiply drop-shadow-sm" />,
      iconBg: "bg-orange-50/50",
      borderColor: "border-r-[6px] border-r-brand-accent",
      lineColor: "bg-brand-accent"
    },
    { 
      title: "Creative Expression", 
      desc: "We encourage creativity and self-expression, helping students discover their unique talents. Through diverse activities, we build confidence, imagination, and innovation.",
      icon: <img src="/3d_icon_pencil.png" alt="Pencil" className="w-11 h-11 object-contain mix-blend-multiply drop-shadow-sm" />,
      iconBg: "bg-orange-50/50",
      borderColor: "border-r-[6px] border-r-brand-accent",
      lineColor: "bg-brand-accent"
    }
  ];

  return (
    <section className="pt-20 pb-8 px-4 sm:px-6 lg:px-8 relative overflow-hidden bg-[#FAFBFC]">
      {/* Abstract Background Elements (Removed Dot Grid) */}
      <div className="absolute top-0 right-0 w-[400px] h-[400px] border-[1px] border-gray-200 rounded-full translate-x-1/2 -translate-y-1/2 -z-10"></div>
      <div className="absolute top-5 right-5 w-[400px] h-[400px] border-[1px] border-gray-200 rounded-full translate-x-1/2 -translate-y-1/2 -z-10"></div>
      <div className="absolute bottom-0 left-0 w-[500px] h-[500px] border-[1px] border-gray-200 rounded-full -translate-x-1/2 translate-y-1/2 -z-10"></div>
      <div className="absolute bottom-5 left-5 w-[500px] h-[500px] border-[1px] border-gray-200 rounded-full -translate-x-1/2 translate-y-1/2 -z-10"></div>

      <div className="max-w-[1400px] mx-auto">
        {/* Header section */}
        <div className="text-center mb-16 space-y-3">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
          >
            <div className="flex items-center justify-center space-x-3 mb-4">
              <span className="w-10 h-[2px] bg-brand-accent rounded-full"></span>
              <span className="w-1.5 h-1.5 rounded-full bg-brand-accent"></span>
              <span className="text-sm font-bold tracking-[0.2em] text-brand-accent uppercase">
                Excellence in Learning
              </span>
              <span className="w-1.5 h-1.5 rounded-full bg-brand-accent"></span>
              <span className="w-10 h-[2px] bg-brand-accent rounded-full"></span>
            </div>
            
            <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif font-bold text-brand-primary tracking-tighter mb-4">
              Curriculum <span className="text-brand-accent italic font-light drop-shadow-sm">Structure</span>
            </h2>
            
            <p className="mt-4 text-gray-500 font-medium text-[1.1rem] max-w-3xl mx-auto leading-relaxed">
              A well-rounded academic approach that nurtures intellectual growth, practical skills, strong values, and creativity, shaping students for sustained success in life.
            </p>
          </motion.div>
        </div>

        {/* 3-Column Layout */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-5 xl:gap-6 items-stretch relative z-10">
          
          {/* Left Column (3 Cards) */}
          <div className="lg:col-span-4 gap-5 flex flex-col h-full">
            {cardsLeft.map((card, idx) => (
              <motion.div
                key={idx}
                initial={{ opacity: 0, x: -30 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ delay: idx * 0.15, duration: 0.8 }}
                className={`flex-1 bg-white p-5 rounded-[20px] shadow-[0_8px_30px_rgb(0,0,0,0.06)] flex flex-row items-center gap-4 ${card.borderColor} hover:-translate-y-1 hover:shadow-xl transition-all duration-300`}
              >
                <div className={`w-14 h-14 rounded-[14px] flex-shrink-0 flex items-center justify-center ${card.iconBg} shadow-sm`}>
                  {card.icon}
                </div>
                <div className="pt-0">
                  <h3 className="text-xl font-bold text-brand-accent mb-1.5 font-serif tracking-tight">{card.title}</h3>
                  <div className={`w-6 h-[2px] mb-2 ${card.lineColor}`}></div>
                  <p className="text-gray-500 text-sm leading-relaxed font-medium">{card.desc}</p>
                </div>
              </motion.div>
            ))}
          </div>

          {/* Center Column (Large Image) */}
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 1, ease: "easeOut" }}
            className="lg:col-span-4 relative min-h-[300px] lg:min-h-0"
          >
            <div className="lg:absolute lg:inset-0 w-full h-full rounded-[24px] overflow-hidden shadow-xl border-[5px] border-white relative z-10">
              <img 
                src="/curriculum_project.jpg" 
                alt="Students with science project" 
                className="w-full h-full object-cover"
              />
            </div>
          </motion.div>

          {/* Right Column (3 Cards) */}
          <div className="lg:col-span-4 gap-5 flex flex-col h-full">
            {cardsRight.map((card, idx) => (
              <motion.div
                key={idx}
                initial={{ opacity: 0, x: 30 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ delay: idx * 0.15, duration: 0.8 }}
                className={`flex-1 bg-white p-5 rounded-[20px] shadow-[0_8px_30px_rgb(0,0,0,0.06)] flex flex-row items-center gap-4 ${card.borderColor} hover:-translate-y-1 hover:shadow-xl transition-all duration-300`}
              >
                <div className={`w-14 h-14 rounded-[14px] flex-shrink-0 flex items-center justify-center ${card.iconBg} shadow-sm`}>
                  {card.icon}
                </div>
                <div className="pt-0">
                  <h3 className="text-xl font-bold text-brand-accent mb-1.5 font-serif tracking-tight">{card.title}</h3>
                  <div className={`w-6 h-[2px] mb-2 ${card.lineColor}`}></div>
                  <p className="text-gray-500 text-sm leading-relaxed font-medium">{card.desc}</p>
                </div>
              </motion.div>
            ))}
          </div>

        </div>

      </div>
    </section>
  );
}
