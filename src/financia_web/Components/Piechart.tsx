'use client'
import PiechartSkeleton from '@/Skeleton/PiechartSkeleton';
import dynamic from 'next/dynamic'

const PieChart = dynamic(
  () => import('@mui/x-charts').then((mod) => mod.PieChart),
  {
    loading: () => <PiechartSkeleton />,
    ssr: false 
  }
);

export default function BasicPie() {
  return (
    <div className="mt-8">
      <PieChart
        series={[
          {
            data: [
              { id: 0, value: 1000, label: 'Gastos' },
              { id: 1, value: 1000, label: 'Ingresos' },
            ],
          },
        ]}
        width={200}
        height={200}
      />
    </div>
  );
}