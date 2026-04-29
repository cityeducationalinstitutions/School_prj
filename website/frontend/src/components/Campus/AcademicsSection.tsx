import { motion } from 'framer-motion';
import { 
  BookOpen, 
  Check, 
  Users, 
  FileText, 
  Award, 
  ArrowRight, 
  Microscope, 
  Palette, 
  Languages,
  UserCheck,
  Heart,
  Globe,
  Star
} from 'lucide-react';

export default function AcademicsSection({
  image = "https://images.unsplash.com/photo-1546410531-bea4f4b971a8?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80"
}: {
  image?: string;
}) {
  const curriculumCards = [
    {
      title: "English & Literature",
      desc: "Building strong communication, comprehension & expression.",
      icon: <BookOpen className="w-5 h-5" />,
    },
    {
      title: "STEM & Innovation",
      desc: "Nurturing curiosity through science, technology & research.",
      icon: <Microscope className="w-5 h-5" />,
    },
    {
      title: "Humanities & Arts",
      desc: "Exploring history, culture, creativity & global perspectives.",
      icon: <Palette className="w-5 h-5" />,
    },
    {
      title: "Languages & Communication",
      desc: "Developing confidence through languages & communication.",
      icon: <Languages className="w-5 h-5" />,
    }
  ];

  const metrics = [
    { label: "Student–Teacher Ratio", value: "1:18", icon: <Users className="w-5 h-5" /> },
    { label: "CBSE Aligned", value: "100%", icon: <UserCheck className="w-5 h-5" /> },
    { label: "Co-Curricular Programs", value: "50+", icon: <Star className="w-5 h-5" /> }
  ];

  return (
    <section className="relative pt-24 pb-10 lg:pt-32 lg:pb-12 bg-[#FAF8F5] overflow-hidden">
      {/* Background Organic Shape */}
      <div className="absolute top-[10%] right-[-5%] w-[60%] h-[70%] bg-[#F4EFE8] rounded-[40%_60%_70%_30%/40%_50%_60%_40%] -z-0 opacity-60 blur-3xl transform rotate-12"></div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-12 relative z-10">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-16 lg:gap-20 items-start">
          
          {/* Left Column: Academic Storytelling */}
          <div className="lg:col-span-5 space-y-10 lg:sticky lg:top-32 pt-0 -mt-9">
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
                Our CBSE-aligned curriculum blends rigorous academics with creativity, critical thinking, and real-world application. We nurture curious minds and confident leaders through holistic learning and meaningful experiences.
              </p>
            </div>

            {/* Premium Quote Card */}
            <div className="relative p-8 bg-[#FAF8F5] border-l-4 border-[#C88A4D]/30 rounded-r-2xl shadow-[0_20px_40px_-15px_rgba(31,42,68,0.03)] group">
              <span className="absolute top-4 left-4 text-[#C88A4D]/20 text-6xl font-serif">“</span>
              <div className="relative z-10 space-y-3">
                <p className="text-[#1F2A44] font-semibold text-lg">We believe every student has a unique potential.</p>
                <p className="text-[#5B6475] text-sm font-light italic">Our academic ecosystem is designed to bring out the best in every learner—every single day.</p>
              </div>
            </div>

            {/* Metrics Row */}
            <div className="grid grid-cols-3 gap-8 pt-2">
              {metrics.map((item, idx) => (
                <div key={idx} className="space-y-3">
                  <div className="w-10 h-10 rounded-full bg-[#1F2A44]/5 flex items-center justify-center text-[#1F2A44]/40">
                    {item.icon}
                  </div>
                  <div>
                    <p className="text-2xl font-serif font-bold text-[#1F2A44] leading-none mb-1">{item.value}</p>
                    <p className="text-[10px] text-[#5B6475] uppercase tracking-wider leading-tight">{item.label}</p>
                  </div>
                </div>
              ))}
            </div>

            {/* CTA Button */}
            <button className="flex items-center gap-3 bg-[#1F2A44] text-white px-10 py-5 rounded-full font-medium transition-all hover:bg-[#1F2A44]/90 hover:scale-105 active:scale-95 shadow-xl shadow-[#1F2A44]/10">
              EXPLORE CURRICULUM
              <ArrowRight className="w-4 h-4" />
            </button>
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
                  <p className="text-[#1F2A44] font-bold text-sm">CBSE</p>
                  <p className="text-[#5B6475] text-[11px] font-medium italic">Aligned</p>
                </div>
              </div>
            </div>

            {/* Curriculum Cards Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 pt-6">
              {curriculumCards.map((card, idx) => (
                <div key={idx} className="group/card bg-white border border-[#E7DED2] p-8 rounded-[1.5rem] transition-all duration-500 hover:shadow-2xl hover:shadow-[#1F2A44]/5 hover:-translate-y-1 relative overflow-hidden">
                  <div className="absolute top-0 right-0 w-32 h-32 bg-[#FAF8F5] rounded-full blur-3xl -z-10 translate-x-1/2 -translate-y-1/2 group-hover/card:bg-[#C88A4D]/5 transition-colors"></div>
                  
                  <div className="flex items-start justify-between mb-6">
                    <div className="w-12 h-12 rounded-xl bg-[#FAF8F5] flex items-center justify-center text-[#1F2A44]/60 group-hover/card:bg-[#1F2A44] group-hover/card:text-white transition-all">
                      {card.icon}
                    </div>
                    <ArrowRight className="w-5 h-5 text-[#C88A4D] opacity-0 group-hover/card:opacity-100 transform -translate-x-4 group-hover/card:translate-x-0 transition-all duration-500" />
                  </div>
                  
                  <h3 className="text-lg font-serif font-bold text-[#1F2A44] mb-3 leading-tight">{card.title}</h3>
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
