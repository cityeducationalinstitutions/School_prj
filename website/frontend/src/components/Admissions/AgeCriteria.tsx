import { motion } from 'framer-motion';

const AgeCriteria = () => {
  const criteria = [
    { grade: "Pre-KG / Nursery", age: "3+ Years", cutOff: "As of 31st March" },
    { grade: "LKG / PP1", age: "4+ Years", cutOff: "As of 31st March" },
    { grade: "UKG / PP2", age: "5+ Years", cutOff: "As of 31st March" },
    { grade: "Grade 1", age: "6+ Years", cutOff: "As of 31st March" },
    { grade: "Grade 2 - 10", age: "As per Transfer Certificate", cutOff: "N/A" }
  ];

  return (
    <section className="py-[clamp(4rem,10vh,8rem)] bg-white relative overflow-hidden">
      <div className="max-w-4xl mx-auto px-6">
        <div className="text-center mb-16 space-y-4">
          <span className="text-xs font-bold tracking-[0.4em] text-brand-accent uppercase block">Eligibility</span>
          <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif text-brand-primary tracking-tighter leading-none">
            Age <span className="text-brand-accent italic font-light">Criteria.</span>
          </h2>
          <div className="w-20 h-1 bg-brand-accent/20 rounded-full mx-auto mt-6"></div>
        </div>

        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="glass-card rounded-[2.5rem] border-white shadow-elite overflow-hidden"
        >
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-brand-primary text-white">
                <th className="px-8 py-6 text-sm font-bold tracking-widest uppercase">Grade / Level</th>
                <th className="px-8 py-6 text-sm font-bold tracking-widest uppercase">Age Requirement</th>
                <th className="px-8 py-6 text-sm font-bold tracking-widest uppercase">Cut-off Date</th>
              </tr>
            </thead>
            <tbody>
              {criteria.map((item, idx) => (
                <tr key={idx} className="border-b border-gray-100 hover:bg-brand-accent/5 transition-colors group">
                  <td className="px-8 py-6 text-brand-primary font-bold">{item.grade}</td>
                  <td className="px-8 py-6 text-gray-600 font-light">{item.age}</td>
                  <td className="px-8 py-6 text-gray-400 font-light text-sm italic">{item.cutOff}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </motion.div>
        
        <p className="mt-10 text-center text-gray-500 font-light text-sm italic">
          * Note: The final decision on grade placement rests with the academic committee based on the interaction session.
        </p>
      </div>
    </section>
  );
};

export default AgeCriteria;
