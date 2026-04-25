import { motion } from 'framer-motion';
import { BookOpen, CheckCircle, FileText, Zap } from 'lucide-react';

const AcademicsSection = () => {
  const points = [
    {
      title: 'Structured Curriculum',
      desc: 'Our curriculum is designed to balance rigor with conceptual understanding at every grade level.',
      icon: BookOpen
    },
    {
      title: 'Conceptual Clarity',
      desc: 'We focus on the "why" so that students can apply knowledge confidently in any context.',
      icon: Zap
    },
    {
      title: 'Continuous Evaluation',
      desc: 'Regular assessments that focus on growth and feedback rather than just grades.',
      icon: FileText
    },
    {
      title: 'Proven Results',
      desc: 'A consistent track record of academic excellence in competitive and board examinations.',
      icon: CheckCircle
    }
  ];

  return (
    <section className="py-24 bg-brand-light">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
          <motion.div
            initial={{ opacity: 0, x: -30 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.8 }}
          >
            <span className="text-brand-accent font-bold tracking-widest uppercase text-sm mb-4 block">Excellence in Learning</span>
            <h2 className="text-4xl md:text-5xl font-serif text-brand-primary mb-8">Academic Standards</h2>
            <p className="text-gray-600 text-lg font-light leading-relaxed mb-10">
              At City Educational Institutions, academic excellence is not just a goal, but a standard we uphold through structured planning and dedicated mentorship.
            </p>
            
            <div className="space-y-6">
              {['National Curriculum Alignment', 'Personalized Learning Paths', 'Digital Integration', 'Expert Faculty Guidance'].map((item, idx) => (
                <div key={idx} className="flex items-center gap-4 group">
                  <div className="w-6 h-6 rounded-full bg-brand-accent/10 flex items-center justify-center group-hover:bg-brand-accent transition-colors">
                    <CheckCircle className="w-4 h-4 text-brand-accent group-hover:text-white transition-colors" />
                  </div>
                  <span className="text-brand-primary font-medium">{item}</span>
                </div>
              ))}
            </div>
          </motion.div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
            {points.map((point, idx) => (
              <motion.div
                key={idx}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: idx * 0.1 }}
                className="bg-white p-8 rounded-3xl shadow-sm border border-gray-100 hover:shadow-md transition-shadow"
              >
                <point.icon className="w-10 h-10 text-brand-accent mb-4" />
                <h3 className="text-xl font-serif font-bold text-brand-primary mb-2">{point.title}</h3>
                <p className="text-gray-500 text-sm leading-relaxed">{point.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};

export default AcademicsSection;
