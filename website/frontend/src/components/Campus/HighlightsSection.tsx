import { motion } from 'framer-motion';

export default function HighlightsSection({
  highlights = []
}: {
  highlights?: Array<{ icon: React.ReactNode, title: string, desc: string }>;
}) {

  return (
    <section className="pt-[clamp(4rem,10vh,8rem)] pb-[clamp(1.5rem,4vh,3rem)] bg-transparent relative overflow-hidden">
      {/* Background Decorative Elements */}
      <div className="absolute top-0 left-0 w-[500px] h-[500px] bg-brand-accent/5 rounded-full blur-[120px] -z-10 -translate-x-1/2 -translate-y-1/2 opacity-60 hidden sm:block"></div>
      <div className="absolute bottom-0 right-0 w-[400px] h-[400px] bg-brand-primary/5 rounded-full blur-[100px] -z-10 translate-x-1/2 translate-y-1/2 opacity-40 hidden sm:block"></div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="text-center max-w-3xl mx-auto mb-24">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="space-y-4"
          >
            <span className="text-[10px] md:text-xs font-bold tracking-[0.4em] text-brand-accent uppercase block mb-4">Distinctive Excellence</span>
            <h2 className="text-[clamp(1.75rem,5.5vh,3.5rem)] font-serif text-brand-primary tracking-tighter leading-tight whitespace-nowrap">
              What Makes Us <span className="text-brand-accent italic font-light drop-shadow-sm">Different.</span>
            </h2>
            <div className="w-24 h-1 bg-brand-accent/20 mx-auto mt-8 mb-8 rounded-full"></div>
            <p className="text-gray-500 font-light text-lg md:text-xl max-w-2xl mx-auto leading-relaxed">
              Our commitment to quality education is reflected in our robust infrastructure and dedicated community.
            </p>
          </motion.div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {highlights.map((item, idx) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: idx * 0.1, duration: 0.8 }}
              className="group relative h-full"
            >
              <div className="h-full bg-white/40 backdrop-blur-xl border border-white/60 p-8 sm:p-10 rounded-[2rem] rounded-tr-[5rem] rounded-bl-[5rem] shadow-[0_20px_50px_-12px_rgba(0,0,0,0.05)] hover:shadow-[0_30px_60px_-15px_rgba(226,135,67,0.15)] hover:-translate-y-2 transition-all duration-700 ease-[cubic-bezier(0.23,1,0.32,1)] overflow-hidden flex flex-col items-center text-center">
                

                <div className="relative z-10 mb-10 w-24 h-24 rounded-3xl bg-brand-accent/5 flex items-center justify-center group-hover:scale-110 group-hover:bg-brand-accent/10 transition-all duration-700 shadow-inner group-hover:shadow-brand-accent/20">
                  <div className="scale-125 transition-transform duration-700">
                    {item.icon}
                  </div>
                </div>
                
                <h3 className="text-2xl font-serif font-bold mb-6 text-brand-primary group-hover:text-brand-accent transition-colors duration-700 tracking-tight leading-tight">
                  {item.title}
                </h3>
                
                <p className="text-gray-500 font-light leading-relaxed text-base transition-colors duration-700">
                  {item.desc}
                </p>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}
