import { GraduationCap, ArrowRight, Calendar, Users, ShieldCheck, Sparkles } from 'lucide-react';

export default function AcademicCTA() {
  return (
    <section className="pt-4 pb-24 bg-brand-light/30 px-4">
      <div className="max-w-7xl mx-auto">
        <div className="relative bg-white rounded-[40px] shadow-[0_20px_80px_rgba(0,0,0,0.06)] overflow-hidden border border-white">
          
          {/* Decorative Elements */}
          <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-brand-accent/5 rounded-full -translate-y-1/2 translate-x-1/4 blur-3xl -z-1"></div>
          <div className="absolute bottom-0 left-0 w-[300px] h-[300px] bg-brand-primary/5 rounded-full translate-y-1/2 -translate-x-1/4 blur-3xl -z-1"></div>

          <div className="grid lg:grid-cols-2 items-center">
            
            {/* Left Content */}
            <div className="p-10 md:p-16 lg:p-20 space-y-10 relative z-10">
              {/* Badge */}
              <div className="inline-flex items-center gap-2.5 px-5 py-2 rounded-full bg-orange-50 border border-orange-100/50">
                <GraduationCap className="w-4 h-4 text-brand-accent" />
                <span className="text-brand-accent text-[11px] font-bold tracking-widest uppercase">
                  Admissions Open 2026–27
                </span>
              </div>

              {/* Heading */}
              <div className="space-y-4">
                <h2 className="text-5xl md:text-6xl font-serif font-bold text-brand-primary leading-[1.1] tracking-tight">
                  Join the <br />
                  <span className="bg-gradient-to-r from-brand-accent to-[#ffb37b] bg-clip-text text-transparent italic">
                    Academic Journey
                  </span>
                </h2>
                <p className="text-gray-500 text-base md:text-lg max-w-md leading-relaxed">
                  Admissions for the upcoming session are now open across all branches. Take the first step towards a strong academic foundation and a future filled with opportunities.
                </p>
              </div>

              {/* CTA Buttons */}
              <div className="flex flex-wrap gap-4 pt-4">
                <button className="group flex items-center gap-3 px-8 py-4 bg-brand-accent text-white text-[11px] font-black tracking-[0.2em] uppercase rounded-xl hover:bg-brand-primary hover:shadow-xl transition-all duration-500 hover:-translate-y-1">
                  Apply Now
                  <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
                </button>
                <button className="flex items-center gap-3 px-8 py-4 border-2 border-brand-primary/5 text-brand-primary text-[11px] font-black tracking-[0.2em] uppercase rounded-xl hover:border-brand-primary hover:bg-brand-primary/5 transition-all duration-500">
                  <Calendar className="w-4 h-4" />
                  Book a Campus Visit
                </button>
              </div>

              {/* Mobile Image (shown only on mobile) */}
              <div className="lg:hidden pt-10">
                <div className="relative rounded-3xl overflow-hidden shadow-2xl">
                  <img 
                    src="/classroom_collaboration.png" 
                    alt="Students studying" 
                    className="w-full h-auto object-cover"
                  />
                </div>
              </div>
            </div>

            {/* Right Image Container (Desktop) */}
            <div className="hidden lg:block relative p-12 pr-16 h-full min-h-[600px]">
              <div className="relative h-full">
                {/* Abstract Background Shapes */}
                <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[120%] h-[120%] bg-brand-accent/5 rounded-[60px] rotate-6 -z-1"></div>
                <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[110%] h-[110%] bg-brand-accent/10 rounded-[60px] -rotate-3 -z-1"></div>
                
                {/* Image Wrapper with Glassmorphism Border */}
                <div className="relative h-full rounded-[40px] overflow-hidden shadow-[0_30px_100px_rgba(0,0,0,0.12)] border-[12px] border-white/30 backdrop-blur-sm z-10 group">
                  <img 
                    src="/classroom_collaboration.png" 
                    alt="Students studying together" 
                    className="w-full h-full object-cover transition-transform duration-1000 group-hover:scale-105"
                  />
                  {/* Overlay Gradient */}
                  <div className="absolute inset-0 bg-gradient-to-t from-brand-primary/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
                </div>
              </div>
            </div>
          </div>

          {/* Bottom Features Strip */}
          <div className="bg-brand-primary/[0.02] border-t border-gray-50 py-10 px-10 md:px-20">
            <div className="grid md:grid-cols-3 gap-10">
              {[
                { icon: <Users className="w-5 h-5" />, title: "Limited Seats Available", desc: "Hurry, enrol today!" },
                { icon: <Sparkles className="w-5 h-5" />, title: "Personalized Learning", desc: "Focus on every child's growth" },
                { icon: <ShieldCheck className="w-5 h-5" />, title: "Safe & Nurturing", desc: "Your child's well-being is our priority" }
              ].map((feature, idx) => (
                <div key={idx} className="flex items-center gap-5 group">
                  <div className="w-12 h-12 rounded-2xl bg-white shadow-sm border border-gray-100 flex items-center justify-center text-brand-accent group-hover:bg-brand-accent group-hover:text-white transition-all duration-300">
                    {feature.icon}
                  </div>
                  <div>
                    <h4 className="text-[13px] font-bold text-brand-primary uppercase tracking-tight">
                      {feature.title}
                    </h4>
                    <p className="text-gray-400 text-[11px]">
                      {feature.desc}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
