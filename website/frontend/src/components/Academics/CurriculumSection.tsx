import { motion } from 'framer-motion';

export default function CurriculumSection() {
  const cardsLeft = [
    { title: "Academic Mastery", desc: "Rigorous focus on core skills and fundamental knowledge." },
    { title: "Critical Thinking", desc: "Encouraging students to question, analyze, and innovate." }
  ];

  const cardsRight = [
    { title: "Character Formation", desc: "Instilling deep-rooted values and ethical principles." },
    { title: "Digital Literacy", desc: "Mastering modern technology for the future landscape." },
    { title: "Creative Expression", desc: "Nurturing the unique artistic voice of every child." }
  ];

  return (
    <section className="py-[clamp(4rem,10vh,8rem)] px-4 sm:px-6 lg:px-8 bg-white relative overflow-hidden">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-20">
          <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif font-bold text-brand-primary tracking-tighter">
            Curriculum <span className="text-brand-accent italic font-light">Structure</span>
          </h2>
        </div>

        <div className="grid lg:grid-cols-3 gap-12 items-center">
          {/* Left Cards */}
          <div className="space-y-8 order-2 lg:order-1">
            {cardsLeft.map((card, idx) => (
              <motion.div
                key={idx}
                initial={{ opacity: 0, x: -30 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ delay: idx * 0.2 }}
                className="glass-card p-6 sm:p-8 rounded-[1.5rem] sm:rounded-[2.5rem] bg-brand-light border-white/60 hover:shadow-xl transition-all group"
              >
                <h3 className="text-2xl font-serif font-bold text-brand-primary mb-3 group-hover:text-brand-accent transition-colors">{card.title}</h3>
                <p className="text-gray-500 font-light leading-relaxed">{card.desc}</p>
              </motion.div>
            ))}
          </div>

          {/* Center Image */}
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            whileInView={{ opacity: 1, scale: 1 }}
            viewport={{ once: true }}
            className="relative order-1 lg:order-2"
          >
            <div className="aspect-[4/5] rounded-[2rem] sm:rounded-[4rem] overflow-hidden shadow-2xl border-4 sm:border-8 border-brand-light relative z-10">
              <img 
                src="/academics_classroom.png" 
                alt="Students in classroom" 
                className="w-full h-full object-cover grayscale"
              />
              <div className="absolute inset-0 bg-brand-primary/10 mix-blend-multiply"></div>
            </div>
            {/* Ambient Background Blur */}
            <div className="absolute -inset-10 bg-brand-accent/5 rounded-full blur-[100px] -z-10"></div>
          </motion.div>

          {/* Right Cards */}
          <div className="space-y-8 order-3">
            {cardsRight.map((card, idx) => (
              <motion.div
                key={idx}
                initial={{ opacity: 0, x: 30 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ delay: idx * 0.2 }}
                className="glass-card p-6 sm:p-8 rounded-[1.5rem] sm:rounded-[2.5rem] bg-brand-light border-white/60 hover:shadow-xl transition-all group"
              >
                <h3 className="text-2xl font-serif font-bold text-brand-primary mb-3 group-hover:text-brand-accent transition-colors">{card.title}</h3>
                <p className="text-gray-500 font-light leading-relaxed">{card.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
