import { useEffect } from 'react';
import AdmissionsHero from '../components/Admissions/AdmissionsHero';
import AdmissionsForm from '../components/Admissions/AdmissionsForm';
import ProcessTimeline from '../components/Admissions/ProcessTimeline';
import AgeCriteria from '../components/Admissions/AgeCriteria';
import MetricsSection from '../components/Campus/MetricsSection';

const Admissions = () => {
  // Scroll to top on load
  useEffect(() => {
    window.scrollTo(0, 0);
  }, []);

  return (
    <div className="bg-brand-light flex flex-col">
      <AdmissionsHero />
      <AdmissionsForm />
      <ProcessTimeline />
      <AgeCriteria />
      <MetricsSection />
    </div>
  );
};

export default Admissions;
