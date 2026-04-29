import { GraduationCap } from 'lucide-react';

export default function TeachingPedagogy() {
  const features = [
    {
      title: "Concept-Based Learning",
      desc: "We emphasize deep understanding of core concepts to build a strong and lasting academic foundation.",
      icon: <img src="/pedagogy_3d_concept.png" alt="Concept-Based Learning" className="w-10 h-10 object-contain mix-blend-multiply drop-shadow-sm" />
    },
    {
      title: "Activity-Based Pedagogy",
      desc: "Hands-on learning experiences that enhance engagement, creativity, and practical application.",
      icon: <img src="/pedagogy_3d_activity.png" alt="Activity-Based Pedagogy" className="w-10 h-10 object-contain mix-blend-multiply drop-shadow-sm" />
    },
    {
      title: "Student Participation & Peer Learning",
      desc: "Encouraging collaboration, communication, and active involvement to strengthen confidence and teamwork.",
      icon: <img src="/pedagogy_3d_participation.png" alt="Student Participation" className="w-10 h-10 object-contain mix-blend-multiply drop-shadow-sm" />
    },
    {
      title: "Continuous & Comprehensive Evaluation",
      desc: "Regular assessments focused on growth, clarity, and mastery rather than rote performance.",
      icon: <img src="/3d_icon_clipboard.png" alt="Evaluation" className="w-10 h-10 object-contain mix-blend-multiply drop-shadow-sm" />
    }
  ];

  return (
    <section className="pt-12 pb-12 bg-white overflow-hidden relative">
      <div className="max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid lg:grid-cols-2 gap-16 xl:gap-20 items-center">
          
          {/* Left Content */}
          <div className="space-y-10">
            <div>
              <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full border border-[#F28C38]/20 bg-[#F28C38]/5 mb-8">
                <GraduationCap className="w-4 h-4 text-[#F28C38]" />
                <span className="text-[#F28C38] text-[10px] font-bold tracking-[0.2em] uppercase">
                  OUR PEDAGOGY
                </span>
              </div>
              <h2 className="text-[clamp(2rem,5vh,3.5rem)] font-serif font-bold text-[#0B1E3C] leading-[1.1] tracking-tight mb-8">
                The Way We <span className="text-[#F28C38] italic">Teach & Inspire</span>
              </h2>
              <div className="space-y-4 max-w-xl">
                <p className="text-gray-500 font-sans text-sm lg:text-base leading-relaxed">
                  We go beyond traditional teaching by building strong academic foundations through meaningful, real-world learning experiences. Our approach fosters curiosity, confidence, and independent thinking, preparing students to grow into capable and future-ready individuals.
                </p>
              </div>
            </div>

            {/* Feature Cards */}
            <div className="space-y-4">
              {features.map((feature, idx) => (
                <div
                  key={idx}
                  className="group flex items-center gap-6 p-5 rounded-[12px] bg-white shadow-[0_4px_25px_rgb(0,0,0,0.03)] border border-gray-100 hover:shadow-md transition-all duration-300 relative overflow-hidden cursor-pointer"
                >
                  {/* Colored Left Bar */}
                  <div className="absolute left-0 top-0 bottom-0 w-[5px] bg-[#F28C38] opacity-0 group-hover:opacity-100 transition-opacity"></div>
                  
                  <div className="w-12 h-12 rounded-full bg-gray-50 flex items-center justify-center shrink-0 group-hover:bg-[#F28C38]/10 transition-colors">
                    {feature.icon}
                  </div>
                  <div className="flex-1">
                    <h3 className="text-lg font-serif font-bold text-[#F28C38] tracking-tight mb-1">
                      {feature.title}
                    </h3>
                    <p className="text-gray-400 text-[11px] leading-tight">
                      {feature.desc}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Right Image Container */}
          <div className="relative">
            <div className="relative rounded-[30px] overflow-hidden shadow-[0_20px_50px_rgba(0,0,0,0.15)] group z-10">
              <img 
                src="/teaching_project.jpg" 
                alt="Students working on a Hydro Power project" 
                className="w-full h-auto object-contain transition-transform duration-700 group-hover:scale-105"
              />
            </div>
          </div>
        </div>

      </div>
    </section>
  );
}
