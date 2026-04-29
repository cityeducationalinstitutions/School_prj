import { motion } from 'framer-motion';
import { User, Shield, Award, Globe } from 'lucide-react';

export default function PrincipalMessage({ 
  campusName = "City Talent",
  principalName = "Dr. Anjali Verma",
  principalImage = "https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=800",
  principalQuote = "At City Talent, we see beauty in every child's potential. Our mission is to provide the canvas upon which they can paint their future with confidence and integrity."
}: { 
  campusName?: string;
  principalName?: string;
  principalImage?: string;
  principalQuote?: string;
}) {
  const values = [
    {
      icon: <Shield className="w-5 h-5" />,
      title: "Character",
      desc: "Building values that last a lifetime."
    },
    {
      icon: <Award className="w-5 h-5" />,
      title: "Excellence",
      desc: "Pursuing the highest standards in all we do."
    },
    {
      icon: <Globe className="w-5 h-5" />,
      title: "Integrity",
      desc: "Doing what is right, even when no one is watching."
    }
  ];

  return (
    <section className="relative pt-8 pb-20 lg:pt-10 lg:pb-28 bg-[#FAF8F5] overflow-hidden">
      {/* Subtle background wash */}
      <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-[#C88A4D]/[0.03] rounded-full blur-[100px] translate-x-1/4 -translate-y-1/4"></div>

      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-12">
        <div className="bg-white rounded-[2rem] border border-[#E9E1D7]/60 shadow-[0_20px_60px_-15px_rgba(31,42,68,0.06)] p-8 md:p-14 lg:p-16">

          <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-16 items-start">

            {/* ── Left: Principal Portrait ── */}
            <motion.div 
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.8, ease: "easeOut" }}
              className="lg:col-span-5 relative"
            >
              <div className="relative">
                {/* Portrait Image */}
                <div className="aspect-[3/4] max-w-[360px] rounded-[1.75rem] overflow-hidden shadow-[0_30px_60px_-12px_rgba(31,42,68,0.15)]">
                  <img 
                    src={principalImage} 
                    alt={principalName}
                    className="w-full h-full object-cover object-top"
                  />
                </div>

                {/* Floating Name Card */}
                <div className="absolute -bottom-6 left-4 right-4 max-w-[320px]">
                  <div className="bg-[#1F2A44] text-white px-6 py-4 rounded-2xl shadow-[0_20px_40px_-10px_rgba(31,42,68,0.4)] flex items-center gap-4">
                    <div className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center shrink-0">
                      <User className="w-5 h-5 text-[#C88A4D]" />
                    </div>
                    <div>
                      <p className="font-serif text-lg font-semibold text-white leading-tight italic">{principalName}</p>
                      <p className="text-[10px] font-bold tracking-[0.25em] uppercase text-white/60 mt-0.5">Principal, CEI</p>
                    </div>
                  </div>
                </div>
              </div>
            </motion.div>

            {/* ── Right: Leadership Content ── */}
            <motion.div 
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.8, delay: 0.15 }}
              className="lg:col-span-7 space-y-8 pt-2"
            >
              {/* Eyebrow + Heading */}
              <div className="space-y-5">
                <span className="text-[11px] font-bold tracking-[0.35em] text-[#C88A4D] uppercase block">
                  Leadership Voice
                </span>

                <h2 className="text-[clamp(2rem,5vh,3.2rem)] font-serif text-[#1F2A44] tracking-tight leading-[1.08]">
                  A Message from our <br />
                  <span className="text-[#C88A4D] italic font-light">Principal.</span>
                </h2>

                {/* Gold accent line */}
                <div className="w-14 h-[3px] bg-[#C88A4D]/40 rounded-full"></div>
              </div>

              {/* Quote */}
              <blockquote className="max-w-lg">
                <p className="text-[#5B6475] text-[1.125rem] leading-[1.8] font-light">
                  "{principalQuote}"
                </p>
              </blockquote>

              {/* Mobile Name */}
              <div className="lg:hidden pt-2">
                <p className="font-serif text-xl font-bold text-[#1F2A44] italic">{principalName}</p>
                <p className="text-[10px] font-bold tracking-[0.3em] text-[#5B6475] uppercase mt-1">Principal, {campusName} Campus</p>
              </div>

              {/* Value Cards Row */}
              <div className="bg-[#FAF8F5] border border-[#E9E1D7]/60 rounded-3xl p-6 md:p-8">
                <div className="grid grid-cols-3 divide-x divide-[#E9E1D7]">
                  {values.map((v, idx) => (
                    <div key={idx} className="text-center px-3 md:px-6 space-y-3">
                      <div className="w-10 h-10 rounded-full bg-[#C88A4D]/10 flex items-center justify-center mx-auto text-[#C88A4D]">
                        {v.icon}
                      </div>
                      <p className="text-[11px] font-bold tracking-[0.2em] uppercase text-[#1F2A44]">{v.title}</p>
                      <p className="text-[12px] text-[#5B6475] leading-relaxed font-light hidden sm:block">{v.desc}</p>
                    </div>
                  ))}
                </div>
              </div>
            </motion.div>

          </div>
        </div>
      </div>
    </section>
  );
}
