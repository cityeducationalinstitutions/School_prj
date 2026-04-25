import { motion } from 'framer-motion';
import lightbulb3d from '../../assets/icons/lightbulb_3d.png';
import target3d from '../../assets/icons/target_3d.png';
import users3d from '../../assets/icons/users_3d.png';
import chart3d from '../../assets/icons/chart_3d.png';

const ApproachSection = () => {
  const approaches = [
    {
      title: 'Concept-Based Learning',
      desc: 'We move beyond rote memorization to build a deep understanding of concepts, enabling students to grasp the “why” and “how” behind every subject.',
      icon: lightbulb3d,
    },
    {
      title: 'Practical Understanding',
      desc: 'We bridge the gap between theory and real-world application through hands-on learning, experiments, and project-based activities.',
      icon: target3d,
    },
    {
      title: 'Student Engagement',
      desc: 'We foster interactive learning environments where every student is encouraged to participate, ask questions, and explore ideas with confidence.',
      icon: users3d,
    },
    {
      title: 'Continuous Improvement',
      desc: 'We follow a dynamic and evolving curriculum, supported by continuous assessment and personalized feedback to ensure consistent student growth.',
      icon: chart3d,
    },
  ];

  return (
    <section className="relative py-[clamp(4rem,10vh,8rem)] bg-transparent overflow-hidden">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-20">
          <span className="text-brand-accent font-bold tracking-[0.2em] uppercase text-xs mb-4 block">Our Methodology</span>
          <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif font-bold mb-8 tracking-tighter leading-tight text-center">
            <span className="text-brand-primary">Our Approach to </span>
            <span className="text-brand-accent">Education</span>
          </h2>
          <div className="w-24 h-1 bg-brand-accent mx-auto rounded-full mt-8"></div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {approaches.map((item, idx) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.6, delay: idx * 0.1 }}
              className="group p-6 sm:p-10 rounded-[1.5rem] sm:rounded-[2.5rem] glass-card glass-card-hover relative overflow-hidden flex flex-col items-center text-center"
            >
              {/* Content Container */}
              <div className="relative z-10 flex flex-col items-center">
                <div className="w-24 h-24 rounded-2xl bg-brand-accent/5 flex items-center justify-center mb-8 transform group-hover:scale-110 transition-transform duration-500">
                  <img src={item.icon} alt={item.title} className="w-20 h-20 object-contain drop-shadow-xl" />
                </div>
                <h3 className="text-2xl font-serif font-bold text-brand-accent mb-4 leading-tight">
                  {item.title}
                </h3>
                <p className="text-gray-500 leading-relaxed text-sm lg:text-base">
                  {item.desc}
                </p>
              </div>

              {/* Decorative accent dot */}
              <div className="absolute top-6 right-6 w-2 h-2 rounded-full bg-brand-accent/20 opacity-0 group-hover:opacity-100 transition-opacity"></div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default ApproachSection;
