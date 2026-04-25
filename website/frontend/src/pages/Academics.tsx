import { useEffect } from 'react';
import AcademicsHero from '../components/Academics/AcademicsHero';
import CurriculumSection from '../components/Academics/CurriculumSection';
import AcademicModel from '../components/Academics/AcademicModel';
import TeachingApproach from '../components/Academics/TeachingApproach';

export default function Academics() {
  // Scroll to top on mount
  useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  return (
    <div className="bg-brand-light">
      <AcademicsHero />
      <CurriculumSection />
      <AcademicModel />
      <TeachingApproach />
      
      {/* Bottom CTA or Decorative Spacer */}
      <section className="py-24 bg-white px-4 text-center">
        <div className="max-w-4xl mx-auto space-y-12">
          <h3 className="text-4xl md:text-5xl font-serif font-bold text-brand-primary tracking-tighter">
            Join the <span className="text-brand-accent">Academic Journey</span>
          </h3>
          <p className="text-gray-500 text-xl">
            Admissions for the upcoming session are now open across all branches.
          </p>
          <div className="flex justify-center gap-6">
            <button className="px-10 py-4 bg-brand-accent text-white text-[11px] font-black tracking-[0.3em] uppercase hover:bg-brand-primary hover:shadow-xl transition-all duration-500">
              Apply Now
            </button>
            <button className="px-10 py-4 border border-brand-primary/10 text-brand-primary text-[11px] font-black tracking-[0.3em] uppercase hover:border-brand-primary hover:text-white transition-all duration-500">
              Inquire
            </button>
          </div>
        </div>
      </section>
    </div>
  );
}
