import { motion } from 'framer-motion';
import { 
  BookOpen, 
  Check, 
  Award, 
} from 'lucide-react';

export default function AcademicsSection({
  image = "/indian_classroom_collaboration.png",
  description1,
  description2
}: {
  image?: string;
  description1?: string;
  description2?: string;
}) {
  const curriculumCards = [
    {
      title: "Core Academic Foundation",
      desc: "Building strong fundamentals in all subjects through structured teaching, clarity of concepts, and consistent practice.",
      icon: <img src="/core_foundation_3d.png" alt="Foundation" className="w-16 h-16 object-contain" />,
    },
    {
      title: "Conceptual Understanding",
      desc: "Focusing on deep learning rather than memorization to ensure students truly understand and apply what they learn.",
      icon: <img src="/conceptual_learning_3d.png" alt="Understanding" className="w-16 h-16 object-contain" />,
    },
    {
      title: "Practice & Reinforcement",
      desc: "Regular worksheets, assignments, and guided practice to strengthen accuracy, speed, and confidence.",
      icon: <img src="/practice_reinforcement_3d.png" alt="Practice" className="w-16 h-16 object-contain" />,
    },
    {
      title: "Examination Readiness",
      desc: "Preparing students with structured revision, test strategies, and performance tracking for strong results.",
      icon: <img src="/exam_readiness_3d.png" alt="Exams" className="w-16 h-16 object-contain" />,
    }
  ];



  return (
    <section className="relative pt-12 pb-24 lg:pt-16 lg:pb-32 bg-[#FAF8F5] overflow-hidden">
      {/* Background Organic Shape */}
      <div className="absolute top-[10%] right-[-5%] w-[60%] h-[70%] bg-[#F4EFE8] rounded-[40%_60%_70%_30%/40%_50%_60%_40%] -z-0 opacity-60 blur-3xl transform rotate-12"></div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-12 relative z-10">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-16 lg:gap-20 items-start">
          
          {/* Left Column: Academic Storytelling */}
          <div className="lg:col-span-5 space-y-10 lg:sticky lg:top-32 pt-0">
            <div className="space-y-4">
              <div className="flex items-center gap-3 text-[#C88A4D]">
                <BookOpen className="w-4 h-4" />
                <span className="text-[11px] font-bold tracking-[0.3em] uppercase">Academic Excellence</span>
              </div>
              
              <h2 className="text-[clamp(2.5rem,6vh,4.2rem)] font-serif text-[#1F2A44] tracking-tight leading-[1.05]">
                Where Learning <br />
                Meets <span className="text-[#C88A4D] italic font-light">Excellence.</span>
              </h2>
              
              <p className="text-[#5B6475] text-lg leading-relaxed max-w-lg font-light">
                {description1 || "We follow a structured State (SSC) curriculum built on strong academic foundations and practical understanding. Our approach emphasizes conceptual clarity, consistent practice, and real-world application to ensure students achieve both academic success and life readiness."}
              </p>
              <p className="text-[#5B6475] text-lg leading-relaxed max-w-lg font-light mt-4">
                {description2 || "Our goal is to strengthen core fundamentals while nurturing curiosity, responsibility, and independent thinking. We prepare students not just for examinations, but for future challenges and opportunities."}
              </p>
            </div>

            {/* Premium Quote Card */}
            <div className="relative p-8 bg-[#FAF8F5] border-l-4 border-[#C88A4D]/30 rounded-r-2xl shadow-[0_20px_40px_-15px_rgba(31,42,68,0.03)] group">
              <span className="absolute top-4 left-4 text-[#C88A4D]/20 text-6xl font-serif">“</span>
              <div className="relative z-10 space-y-3">
                <p className="text-[#1F2A44] font-semibold text-lg">“Every student has the potential to achieve excellence with the right foundation and guidance.”</p>
                <p className="text-[#5B6475] text-sm font-light italic">Our academic system is designed to consistently support progress, strengthen basics, and bring out the best in every learner.</p>
              </div>
            </div>

          </div>

          {/* Right Column: Visual Composition & Cards */}
          <div className="lg:col-span-7 space-y-12 pt-0">
            {/* Layered Visual Composition */}
            <div className="relative group max-w-2xl">
              <div className="relative aspect-[16/5.5] overflow-hidden rounded-[2.5rem] shadow-[0_40px_80px_-20px_rgba(31,42,68,0.12)]">
                <img 
                  src={image} 
                  alt="Students learning" 
                  className="w-full h-full object-cover transform transition-transform duration-[3s] group-hover:scale-105"
                />
                <div className="absolute inset-0 bg-[#1F2A44]/5"></div>
              </div>

              {/* Floating Stat Card (Bottom Left) */}
              <motion.div 
                initial={{ opacity: 0, x: -20 }}
                whileInView={{ opacity: 1, x: 0 }}
                className="absolute -bottom-8 -left-8 bg-white/80 backdrop-blur-xl p-8 rounded-[2rem] shadow-[0_30px_60px_-12px_rgba(31,42,68,0.15)] border border-white/50 z-20 max-w-[200px]"
              >
                <div className="flex items-center gap-3 mb-3">
                  <div className="w-8 h-8 rounded-lg bg-[#C88A4D]/10 flex items-center justify-center text-[#C88A4D]">
                    <Award className="w-4 h-4" />
                  </div>
                  <span className="text-3xl font-serif font-bold text-[#1F2A44]">98%</span>
                </div>
                <p className="text-sm font-semibold text-[#1F2A44] mb-1">Academic Distinction</p>
                <p className="text-[10px] text-[#5B6475] uppercase tracking-widest">Board Performance</p>
              </motion.div>

              {/* Floating Badge (Top Right) */}
              <div className="absolute -top-6 -right-6 bg-white p-6 rounded-[2rem] shadow-xl border border-[#E7DED2]/50 flex items-center gap-4 z-20">
                <div className="w-12 h-12 rounded-full bg-[#1F2A44] flex items-center justify-center text-white">
                  <Check className="w-6 h-6" />
                </div>
                <div className="pr-4">
                  <p className="text-[#1F2A44] font-bold text-sm">SSC</p>
                  <p className="text-[#5B6475] text-[11px] font-medium italic">Aligned</p>
                </div>
              </div>
            </div>

            {/* Curriculum Cards Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 pt-6">
              {curriculumCards.map((card, idx) => (
                <div key={idx} className="bg-white border border-[#E7DED2] p-8 rounded-[1.5rem] relative overflow-hidden">
                  <div className="flex items-start justify-between mb-6">
                    <div className="w-20 h-20 rounded-2xl bg-[#FAF8F5] flex items-center justify-center">
                      {card.icon}
                    </div>
                  </div>
                  
                  <h3 className="text-lg font-serif font-bold text-[#C88A4D] mb-3 leading-tight">{card.title}</h3>
                  <p className="text-[#5B6475] text-sm font-light leading-relaxed pr-4">{card.desc}</p>
                </div>
              ))}
            </div>
          </div>

        </div>


      </div>
    </section>
  );
}
