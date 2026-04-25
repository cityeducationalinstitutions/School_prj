import { motion } from 'framer-motion';
import { ShieldCheck, Monitor, Heart, GraduationCap, Award } from 'lucide-react';

const Differentiators = () => {
  const highlights = [
    {
      id: '01',
      title: 'Experienced Faculty',
      desc: 'Our teachers are mentors with decades of collective experience in academic leadership, fostering a culture of mentorship.',
      icon: GraduationCap,
    },
    {
      id: '02',
      title: 'Technology-Enabled',
      desc: 'Smart classrooms equipped with modern digital tools and AI-assisted learning to enhance global competency.',
      icon: Monitor,
    },
    {
      id: '03',
      title: 'Student-Focused',
      desc: 'We maintain optimal 1:15 student-teacher ratios, ensuring every child receives personalized attention.',
      icon: Heart,
    },
    {
      id: '04',
      title: 'Balanced Excellence',
      desc: 'A perfect synergy between rigorous academics and national-level co-curricular development tracks.',
      icon: Award,
    },
    {
      id: '05',
      title: 'Strong Values',
      desc: 'Integrity and discipline form the core of our culture, preparing students to be responsible global citizens.',
      icon: ShieldCheck,
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
                <div className="w-16 h-16 rounded-2xl bg-brand-accent flex items-center justify-center mb-10 group-hover:rotate-12 transition-all duration-700 shadow-xl shadow-brand-accent/20">
                  <item.icon className="w-8 h-8 text-white" />
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
