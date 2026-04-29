import AboutHero from '../components/About/AboutHero';
import FacilitiesSection from '../components/About/FacilitiesSection';
import SmartSchoolApp from '../components/SmartSchoolApp';

const Facilities = () => {
  return (
    <div className="flex flex-col">
      <AboutHero 
        title="World-Class"
        subtitle="Facilities"
        description="Our campus offers a safe, modern, and inspiring environment with well-equipped classrooms and advanced labs, designed to build strong academic foundations. We nurture curiosity, discipline, and active learning to support every student’s growth and confidence."
        image="/facilities_hero_authentic.jpg"
      />
      <FacilitiesSection />
      <SmartSchoolApp />
    </div>
  );
};

export default Facilities;
