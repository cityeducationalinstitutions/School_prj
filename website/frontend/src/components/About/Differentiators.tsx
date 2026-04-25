import { motion } from 'framer-motion';
import faculty3d from '../../assets/icons/faculty_3d.png';
import tech3d from '../../assets/icons/tech_3d.png';
import student3d from '../../assets/icons/student_3d.png';
import balance3d from '../../assets/icons/balance_3d.png';
import values3d from '../../assets/icons/values_3d.png';
import early3d from '../../assets/icons/early_3d.png';

const Differentiators = () => {
  const highlights = [
    {
      id: '01',
      title: 'Experienced Faculty',
      desc: 'Our educators are accomplished mentors with years of academic expertise and classroom experience. They guide students with a strong commitment to excellence, fostering a culture of continuous learning and meaningful mentorship.',
      icon: faculty3d,
    },
    {
      id: '02',
      title: 'Technology-Enabled',
      desc: 'We integrate modern digital tools and smart classroom solutions to enhance the learning experience. Our technology-driven approach equips students with the skills and adaptability required to thrive in a rapidly evolving global environment.',
      icon: tech3d,
    },
    {
      id: '03',
      title: 'Student-Centered',
      desc: 'Every student receives personalized attention through optimal teacher-student ratios. We focus on individual learning styles, ensuring that each child progresses with confidence, clarity, and academic strength.',
      icon: student3d,
    },
    {
      id: '04',
      title: 'Balanced Excellence',
      desc: 'We maintain a strong balance between rigorous academics and co-curricular development. Our approach nurtures intellectual growth while encouraging creativity, collaboration, and holistic development.',
      icon: balance3d,
    },
    {
      id: '05',
      title: 'Strong Values',
      desc: 'Integrity, discipline, and responsibility form the foundation of our educational philosophy. We cultivate ethical thinking and character development, preparing students to become responsible and respectful global citizens.',
      icon: values3d,
    },
    {
      id: '06',
      title: 'Early Learning Excellence',
      desc: 'For our youngest learners (Pre-KG to Grade 2), we implement the Kerdo Method—a specialized approach focused on experiential, hands-on learning in language, numeracy, and social interaction.',
      icon: early3d,
    },
  ];

  return (
    <section className="py-[clamp(4rem,10vh,8rem)] bg-white overflow-hidden">
      {/* Decorative Background Blob */}
      <div className="absolute top-1/2 right-0 w-[500px] h-[500px] bg-brand-accent/5 rounded-full blur-[100px] translate-x-1/2 -z-10 hidden sm:block"></div>
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="max-w-3xl mb-20 text-center mx-auto">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.8 }}
          >
            <span className="text-brand-accent font-bold tracking-[0.3em] uppercase text-xs mb-4 block">The Pillars of City</span>
            <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif text-brand-primary tracking-tighter leading-none">
              The <span className="text-brand-accent">Institutional</span> <br />
              Differentiators.
            </h2>
            <p className="text-gray-500 text-lg sm:text-xl leading-relaxed mt-8">
              We go beyond the traditional syllabus to ensure our students are 
              academically sound, value-driven, and ready for global challenges.
            </p>
          </motion.div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-10">
          {highlights.map((item, idx) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, scale: 0.95 }}
              whileInView={{ opacity: 1, scale: 1 }}
              viewport={{ once: true }}
              transition={{ duration: 0.7, delay: idx * 0.1, ease: "easeOut" }}
              className="group relative p-6 sm:p-12 rounded-[2rem] sm:rounded-[3.5rem] glass-card glass-card-hover flex flex-col items-center text-center"
            >
              <div className="relative z-10 flex flex-col items-center">
                <div className="w-24 h-24 rounded-2xl bg-brand-accent/5 flex items-center justify-center mb-10 group-hover:scale-110 transition-all duration-700">
                  <img src={item.icon} alt={item.title} className="w-20 h-20 object-contain drop-shadow-xl" />
                </div>
                
                <h3 className="text-2xl font-serif font-bold text-brand-accent mb-6 tracking-tight leading-none uppercase tracking-wider">
                  {item.title}
                </h3>
                <p className="text-gray-500 leading-relaxed text-base tracking-tight group-hover:text-gray-700 transition-colors">
                  {item.desc}
                </p>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Differentiators;
