import { useEffect } from 'react';
import AcademicsHero from '../components/Academics/AcademicsHero';
import CurriculumSection from '../components/Academics/CurriculumSection';
import AcademicModel from '../components/Academics/AcademicModel';
import TeachingPedagogy from '../components/Academics/TeachingPedagogy';
import AcademicCTA from '../components/Academics/AcademicCTA';

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
      <TeachingPedagogy />
      <AcademicCTA />
    </div>
  );
}
