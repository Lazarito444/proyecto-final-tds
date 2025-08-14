import React from "react"
import ContentLoader from "react-content-loader"

type Props = {
  
}
const PieChartSkeleton = (props: Props) => (
  <ContentLoader 
    speed={2}
    width={400}
    height={200}
    viewBox="0 -20 400 250"
    backgroundColor="#f3f3f3"
    foregroundColor="#ecebeb"
    {...props}
  >
    <circle cx="139" cy="110" r="110" /> 
    <rect x="263" y="112" rx="0" ry="0" width="108" height="11" /> 
    <rect x="261" y="142" rx="0" ry="0" width="108" height="11" />
  </ContentLoader>
)

export default PieChartSkeleton

